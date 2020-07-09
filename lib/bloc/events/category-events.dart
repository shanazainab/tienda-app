import 'package:equatable/equatable.dart';

abstract class CategoryEvents extends Equatable {
  CategoryEvents();

  @override
  List<Object> get props => null;
}

class LoadCategories extends CategoryEvents {

  LoadCategories() : super();

  @override
  List<Object> get props => [];
}
