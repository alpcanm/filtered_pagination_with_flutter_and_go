import 'package:bloc/bloc.dart';
import 'package:pagination_app/core/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:pagination_app/core/repository/product_repo.dart';

import '../core/tools/get_it_locator.dart';
part 'pagination_event.dart';
part 'pagination_state.dart';

const int _currentIndex = 0;

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  //Repository sağlayıcımız ile çağırıyoruz.
  final _productRepo = getIt<ProductRepo>();
  PaginationBloc() : super(const PaginationState()) {
    on<PaginationFetch>(_onPaginationFetch);
    // bloc çalışır çalışmaz çağırma methodunu tetikliyoruz.
    add(const PaginationFetch());
  }

  Future<void> _onPaginationFetch(
      PaginationFetch event, Emitter<PaginationState> emit) async {
    // eğer filtreli arama yaparsak her şeyi sıfırlamamız gerekiyor bu yüzden event.status=initial veriyoruz.
    //Bruası sadece filtreli aramalarda bir kere çalışacak.
    if (event.status == PaginationStatus.initial) {
      emit(
        state.copyWith(
            products: [],
            lastProductIndex: _currentIndex,
            hasReachedMax: false,
            status: PaginationStatus.initial,
            isFiltered: true),
      );
    }
    //tüm gelen başka veri yoksa direkt metoddan çıkacak.
    if (state.hasReachedMax) return;
    // PaginationFetch ilk tetiklendiğinde burası çalışacak
    if (state.status == PaginationStatus.initial) {
      final _products = await _productRepo.getProducts(state.lastProductIndex,
          filters: event.filters);

      if (_products != null && _products.isNotEmpty) {
        //gelen verileri içeriye atacak ve metodu sonlandıracak.
        return emit(
          state.copyWith(
              hasReachedMax: false,
              products: _products,
              status: PaginationStatus.success,
              lastProductIndex: _products.last.date,
              isFiltered: true),
        );
      } else {
        //gelen veri null ise failure dönecek
        return emit(
          state.copyWith(status: PaginationStatus.failure),
        );
      }
    }
    //verileri repodan istiyoruz.
    final _products = await _productRepo.getProducts(state.lastProductIndex,
        filters: event.filters);
    if (_products == null || _products.isEmpty) {
      // Eğer gelen veri artık boşsa hasReachedMax=true olacak ve bundan sonra istek atmayacak.
      emit(state.copyWith(hasReachedMax: true));
    } else {
      // her "Daha Fazla" butonuna basıldığında burası tetiklenecek
      emit(
        state.copyWith(
            status: PaginationStatus.success,
            hasReachedMax: false,
            products: List.of(state.products)..addAll(_products),
            lastProductIndex: _products.last.date,
            isFiltered: true),
      );
    }
  }
}
