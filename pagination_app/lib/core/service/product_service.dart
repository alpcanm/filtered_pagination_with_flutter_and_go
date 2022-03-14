// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';

String SERVER_BASE_URL = 'http://10.0.2.2:3000'; //Emulator için
// String SERVER_BASE_URL = 'http://localhost:3000'; //Web için

class ProductService {
  final Dio _dio = Dio();
  Future<dynamic> getProducts(int startIndex, {Set<String>? filters}) async {
    //filtreyi replace ediyoruz.
    final String _query = _replaceFilter(filters);
    // queryParameters a parametrelerimizi atıyoruz. ve isteğimizi gönderiyoruz.
    Response _response = await _dio.get(SERVER_BASE_URL,
        queryParameters: {"greater": startIndex, "tags": _query});
    //Gelence cevap 200 status code ise response modelimize göre içindeki datayı çekiyoruz.
    if (_response.statusCode == 200) {
      return _response.data["body"]["data"];
    }
    return null;
  }

//filtre verileri bize => {kirmizi, mavi} şeklinde gelecek bizde içerisindeki boşlukları ve süslü parantezleri yok ediyoruz.
//Sonra bir string olarak geri döndürüyoruz şu hale dönmüş oluyor => kirmizi,mavi
  String _replaceFilter(Set<String>? filters) {
    if (filters == null) {
      return "";
    }
    String primarySplit = filters.toString().replaceAll(" ", "");
    String secondarySplit = primarySplit.toString().replaceAll("{", "");
    String query = secondarySplit.toString().replaceAll("}", "");
    return query;
  }
}
