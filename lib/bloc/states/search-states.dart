import 'package:equatable/equatable.dart';
import 'package:tienda/model/search-history-response.dart';
import 'package:tienda/model/suggestion-response.dart';

abstract class SearchStates extends Equatable {
  SearchStates();

  @override
  List<Object> get props => null;
}

class Loading extends SearchStates {
  Loading() : super();
}

class ProductSearchAutoCompleteSuccess extends SearchStates {
  final List<Suggestion> suggestions;

  ProductSearchAutoCompleteSuccess(this.suggestions) : super();

  @override
  List<Object> get props => suggestions;
}
class NoSuggestions extends SearchStates {

  NoSuggestions() : super();

  @override
  List<Object> get props => [];
}
class LoadSearchHistoryComplete extends SearchStates {

  final SearchHistoryResponse searchHistoryResponse;

  LoadSearchHistoryComplete(this.searchHistoryResponse) : super();

  @override
  List<Object> get props => [];
}
