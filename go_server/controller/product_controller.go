package controller

import (
	"context"
	"fmt"
	"net/http"
	"pagination_api/config"
	"pagination_api/models"
	"strconv"
	"strings"
	"time"

	"github.com/labstack/echo/v4"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// veritabanı oluşturur ve products adında bir koleksyionu çeker.
var collection *mongo.Collection = config.GetCollection(config.DB, "products")

// Post isteği ile yeni bir product veritabanına kaydeden metod.
func InsertAProduct(c echo.Context) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	// modelimizi tanımlıyoruz
	var product models.Product
	// post attığımızda gelen istekteki verileri modelimize bind ediyoruz.
	if err := c.Bind(&product); err != nil {
		//bir hata varsa döner
		fmt.Println(err.Error())
		return c.JSON(http.StatusBadRequest, models.Response{Message: err.Error()})
	}
	// gelen veriyi veri yukarıda tanımladığımız koleksyionun içerisine insert ediyoruz.
	result, err := collection.InsertOne(ctx, product)
	if err != nil {
		fmt.Println(err.Error())
		return c.JSON(http.StatusBadRequest, models.Response{Message: err.Error()})
	}
	//Tüm işlemler başarılıysa bize mongodb bson veri tipinde bir cevap dönecek.
	return c.JSON(http.StatusCreated, models.Response{Body: &echo.Map{"data": result}})

}

func GetProducts(c echo.Context) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	// tag parametresinini içinin boş olup olmadığını kontrol ediyoruz.
	var isTagActive bool
	if c.QueryParam("tags") != "" {
		isTagActive = true
	}
	//greater parametresini gtFilters methoduna gönderiyoruz ve mongodb de sorgu çekilebilecek modele dönüştürüyoruz
	greaterFilter := gtFilters(c.QueryParam("greater"))
	// tags parametresini tagFilters fonskiyonuna gönderip mongodb de sorug çekilebiecel modele dönüştürüyoruz.
	tagParams := tagFilters(c.QueryParam("tags"))
	// date e göre sıralayalacağımız için aşağıdaki modeli dolduruyoruz.
	sortValue := bson.D{{Key: "date", Value: 1}}          //Value= 1 artan Value=-1 azalan anlamına geliyor.
	opts := options.Find().SetSort(sortValue).SetLimit(2) //date e göre sırala ve 10 tane veri getir dediğimiz opsiyon.
	//son olarakta find methodumuz. Tanımladığımız bütün değişkenleri buraya ekleyerek verileri çekiyoruz.
	resultList, err := collection.Find(ctx, filterCheck(greaterFilter, tagParams, isTagActive), opts)
	if err != nil {
		panic(err)
	}
	//Product modellerimizi içine koyacağımız listeyi tanımlıyoruz.
	var results []*models.Product
	// resultList ten gelen bütün verileri tek tek results içerisine atan method
	if err := resultList.All(ctx, &results); err != nil {
		panic(err)
	}
	// son olarak eğer hiç bir hata yoksa results listesini cevap olarak döndürüyoruz.
	return c.JSON(http.StatusOK, models.Response{Body: &echo.Map{"data": results}})
}

// filterCheck fonksiyonu eğer tag girilmez ise sadece date e göre sıralanmış verileri getirecek. tag girilir ise hem date e hem tag eşitliğine göre verileri getirecek
func filterCheck(gtFilter primitive.E, tagFilters primitive.E, isTagActive bool) bson.D {
	if isTagActive {
		return bson.D{gtFilter, tagFilters}
	}
	return bson.D{gtFilter}
}

func gtFilters(gtParam string) primitive.E {
	// gelen veri strin olarak geliyor ilk önce onu integer a dönüştürüyoruz
	queryRaffleDate, err := strconv.Atoi(gtParam)
	if err != nil {
		panic(err)
	}
	// bson.D mongodb nin kendi veri tipi. "$gt" =  greaterthan demek. yani valueye verilen değerden büyük olanları getirecek.
	greaterThan := bson.D{{Key: "$gt", Value: queryRaffleDate}}
	//son olarak filtreleri dönüştürdüğümüz primitive.E veritipinin içine koyup methodu döndürerek filtremizi hazırlamış oluyoruz.
	return primitive.E{Key: "date", Value: greaterThan}

}

// gelecek olan parametre örneği : tags=kirmizi,sari,mavi
func tagFilters(tagsParam string) primitive.E {
	//tagsParam=kirmizi,mavi,sari tarzında olacağı için önce virgülleri kaldırıp tüm parametreleri bir listeye atıyoruz.
	tagList := strings.Split(tagsParam, ",")
	var equalList []bson.D
	//tagList listesi içerisindeki verileri mongdodb nin anlayacağı modele dönüştürüyoruz
	for _, b := range tagList {
		//tag i value olanları getir anlamına gelen model. value içerisinde de "$eq"= equalTo demektir.
		// Aşağıdaki modelin açıklaması: Mesela "tag equal to kirmizi" olanlar.
		// Tüm filtre modellerimizi equalList listesine ekliyoruz
		equalList = append(equalList, bson.D{{Key: "tag", Value: bson.D{{Key: "$eq", Value: b}}}})
	}
	//Filtrede kullanabileceğimiz modele dönüştürüyoruz. "$or"=veya demek. Bu senaryoda kullanımı şu şekilde olacak:
	// tag equalTo kirmizi or tag equalto mavi or tagEqualto sari
	return primitive.E{Key: "$or", Value: equalList}
}
