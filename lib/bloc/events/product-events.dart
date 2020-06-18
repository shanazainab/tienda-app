import 'package:equatable/equatable.dart';

abstract class ProductEvents extends Equatable {
  ProductEvents();

  @override
  List<Object> get props => null;
}

class FetchProductList extends ProductEvents {
  FetchProductList() : super();

  @override
  List<Object> get props => [];
}
