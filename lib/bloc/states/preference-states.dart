import 'package:equatable/equatable.dart';
import 'package:tienda/model/category.dart';
import 'package:tienda/model/country.dart';

abstract class PreferenceStates extends Equatable {
  PreferenceStates();

  @override
  List<Object> get props => null;
}

class Loading extends PreferenceStates {
  Loading() : super();
}

class LoadCountryListSuccess extends PreferenceStates {
  final List<Country> countries;

  LoadCountryListSuccess({this.countries}) : super();

  @override
  List<Object> get props => countries;
}

class LoadCountryListFail extends PreferenceStates {
  final dynamic error;

  LoadCountryListFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class LoadCategoryListSuccess extends PreferenceStates {
  final List<Category> categories;

  LoadCategoryListSuccess({this.categories}) : super();

  @override
  List<Object> get props => categories;
}

class LoadCategoryListFail extends PreferenceStates {
  final dynamic error;

  LoadCategoryListFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class FetchCountryPreferenceSuccess extends PreferenceStates {
  final Country country;

  FetchCountryPreferenceSuccess({this.country}) : super();

  @override
  List<Object> get props => [country];
}