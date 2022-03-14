import 'package:pagination_app/core/model/product_model.dart';
import 'package:pagination_app/core/service/product_service.dart';
import 'package:pagination_app/core/tools/get_it_locator.dart';

class ProductRepo {
  //productSerivce instance imizi çağırıyoruz.
  final _productService = getIt<ProductService>();
  Future<List<ProductModel>?> getProducts(int startIndex,
      {Set<String>? filters}) async {
    List<ProductModel> _result = [];
    //productSerivce e istek gönderilir.
    final _response =
        await _productService.getProducts(startIndex, filters: filters);
    if (_response != null) {
      for (var item in _response) {
        //gelen cevap null değilse içerisindeki veriler ProductModele dönüştürülür ve liste içerisine atılır.
        _result.add(ProductModel.fromMap(item));
      }
      return _result;
    }
    return null;
  }
}
