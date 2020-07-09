class Filter {
  String id;
  String name;
  List<SubFilter> subFilters;
  bool isFilterApplied;
  int minValue;
  int maxValue;
  Filter({this.id, this.name, this.subFilters, this.isFilterApplied,this.minValue,this.maxValue});
}

class SubFilter {
  String id;
  String name;
  String noOfProducts;
  bool isSubFilterApplied;



  SubFilter({this.id, this.name, this.noOfProducts});
}
