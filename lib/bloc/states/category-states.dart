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

class SwitchCategory extends CategoryStates {
  final Category category;

  SwitchCategory(this.category) : super();

  @override
  List<Object> get props => [category];
}

class LoadCategoriesSuccess extends CategoryStates {
  final List<Category> categories;

  LoadCategoriesSuccess(this.categories) : super();

  @override
  List<Object> get props => categories;
}

class LoadCategoriesFailed extends CategoryStates {
  final dynamic error;

  LoadCategoriesFailed(this.error) : super();

  @override
  List<Object> get props => error;
}
