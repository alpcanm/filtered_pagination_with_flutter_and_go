part of 'pagination_bloc.dart';

enum PaginationStatus { initial, success, failure }

class PaginationState extends Equatable {
  const PaginationState({
    this.status = PaginationStatus.initial,
    this.products = const <ProductModel>[],
    this.hasReachedMax = false,
    this.lastProductIndex = 0,
  });

  final PaginationStatus status;
  final List<ProductModel> products;
  final bool hasReachedMax;
  final int lastProductIndex;

  PaginationState copyWith({
    PaginationStatus? status,
    List<ProductModel>? products,
    bool? hasReachedMax,
    bool? isFiltered,
    int? lastProductIndex,
  }) {
    return PaginationState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastProductIndex: lastProductIndex ?? this.lastProductIndex,
    );
  }

  @override
  List<Object> get props => [status, products, hasReachedMax, lastProductIndex];
}
