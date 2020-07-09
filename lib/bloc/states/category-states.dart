import 'package:equatable/equatable.dart';
import 'package:tienda/model/category.dart';

abstract class CategoryStates extends Equatable {
  CategoryStates();

  @override
  List<Object> get props => null;
}

class Loading extends CategoryStates {
  Loading() : super();
}

abstract class HomeStates extends Equatable {
  HomeStates();

  @override
  List<Object> get props => null;
}



class LoadCategoriesSuccess extends CategoryStates {
  final List<Category> categories;
  final Category selectedCategory;
  LoadCategoriesSuccess({this.categories,this.selectedCategory}) : super();

  @override
  List<Object> get props => [categories,selectedCategory];
}

class LoadCategoriesFailed extends CategoryStates {
  final dynamic error;

  LoadCategoriesFailed(this.error) : super();

  @override
  List<Object> get props => error;
}
