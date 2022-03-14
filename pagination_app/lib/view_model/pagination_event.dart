part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object> get props => [];
}

class PaginationFetch extends PaginationEvent {
  // eğer ki filterli arama yapıcaksak status initial verebilmek için status parametres ekledik.
  final PaginationStatus? status;
  //filtreleri yanlışlıkla da olsa iki defa eklememek için List veri tipi yerine Set veri tipi kullandık.
  final Set<String>? filters;
  const PaginationFetch({this.status, this.filters});
}
