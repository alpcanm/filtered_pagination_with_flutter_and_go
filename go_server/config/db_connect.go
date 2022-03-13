package config

import (
	"context"
	"fmt"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

func connectDB() *mongo.Client {
	// 10 saniye bağlantı olmazsa iptal edecek context.
	ctx, _ := context.WithTimeout(context.Background(), time.Second*10)
	// Veritabanına bağlan
	client, err := mongo.Connect(ctx, options.Client().ApplyURI(MongoURI()))
	// hata kontrolü
	if err != nil {
		log.Fatal(err)
	}
	// veritabanına ping atıyorsa bağlantı başarılıdır.
	if err := client.Ping(ctx, readpref.Primary()); err != nil {
		panic(err)
	}
	fmt.Println("Bağlanıt başarılı.")

	return client
}

// veritabanı instance'ımız.
var DB *mongo.Client = connectDB()

// collections'u çektiğimiz methodumuz.
func GetCollection(client *mongo.Client, collectionName string) *mongo.Collection {
	collection := client.Database("pagination-collection").Collection(collectionName)
	return collection
}
