import 'package:get_it/get_it.dart';
import 'package:pagination_app/core/repository/product_repo.dart';
import 'package:pagination_app/core/service/product_service.dart';

import '../../view/components/_tag_list.dart';

final getIt = GetIt.instance;
void setupGetIt() {
  //Bloc içerisinde kullanmak amacıyla ProductRepo sınıfından global lazy instance'imizi oluşturuyoruz.
  getIt.registerLazySingleton<ProductRepo>(() => ProductRepo());
  //servis sağlayıcımızı oluşturuyoruz.
  getIt.registerLazySingleton<ProductService>(() => ProductService());

  getIt.registerLazySingleton<TagList>(() => TagList());
}
