import 'package:tienda/model/product-list-response.dart';

abstract class FilterStates {
  FilterStates();
}

class Loading extends FilterStates {
  Loading() : super();
}

class LoadFilterSuccess extends FilterStates {
  List<Filter> filters;

  LoadFilterSuccess(this.filters) : super();
}

class UpdateFilterSuccess extends FilterStates {
  List<Filter> filters;

  UpdateFilterSuccess(this.filters) : super();
}
