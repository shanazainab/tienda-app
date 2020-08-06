import 'package:tienda/model/product-list-response.dart';

abstract class FilterEvents {
  FilterEvents();
}

class LoadFilters extends FilterEvents {
  final List<Filter> filters;

  LoadFilters(this.filters) : super();
}
