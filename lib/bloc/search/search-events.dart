import 'package:equatable/equatable.dart';

abstract class SearchEvents extends Equatable {
  SearchEvents();

  @override
  List<Object> get props => null;
}

class ProductSearchAutocomplete extends SearchEvents {
  final String query;

  ProductSearchAutocomplete(this.query) : super();

  @override
  List<Object> get props => [query];
}

class StopSuggestions extends SearchEvents {
  StopSuggestions() : super();

  @override
  List<Object> get props => [];
}

class LoadSearchHistory extends SearchEvents {
  LoadSearchHistory() : super();

  @override
  List<Object> get props => [];
}
