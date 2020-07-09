import 'package:equatable/equatable.dart';

class Product extends Equatable {
  int categoryId;
  int id;
  bool isAvailable;
  String nameArabic;
  String nameEnglish;
  double price;
  String sellerId;
  String subCategoryId;
  String thumbnail;
  double discount;

  bool isWishListed;

  Product(
      {this.categoryId,
      this.id,
      this.isAvailable,
      this.nameArabic,
      this.nameEnglish,
      this.price,
      this.sellerId,
      this.subCategoryId,
      this.thumbnail,
      this.discount,
      this.isWishListed});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        categoryId: json['category_id'],
        id: json['id'],
        isAvailable: json['is_available'],
        nameArabic: json['name_ar'],
        nameEnglish: json['name_en'],
        price: json['price'],
        sellerId: (json['seller_id']),
        subCategoryId: json['sub_category_id'],
        thumbnail: json['thumbnail'],
        discount: json['discount'],
        isWishListed: json['is-wish-listed']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['id'] = this.id;
    data['is_available'] = this.isAvailable;
    data['name_ar'] = this.nameArabic;
    data['name_en'] = this.nameEnglish;
    data['price'] = this.price;
    data['thumbnail'] = this.thumbnail;
    data['seller_id'] = this.sellerId;

    data['sub_category_id'] = this.subCategoryId;
    data['discount'] = this.discount;
    data['is-wish-listed'] = this.isWishListed;

    return data;
  }

  @override
  // TODO: implement stringify
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object> get props => [isWishListed];
}
