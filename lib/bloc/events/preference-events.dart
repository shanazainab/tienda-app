import 'package:equatable/equatable.dart';

abstract class PreferenceEvents extends Equatable {
  PreferenceEvents();

  @override
  List<Object> get props => null;
}

class FetchCountryList extends PreferenceEvents {
  FetchCountryList() : super();

  @override
  List<Object> get props => [];
}

class FetchCategoryList extends PreferenceEvents {
  FetchCategoryList() : super();

  @override
  List<Object> get props => [];
}
