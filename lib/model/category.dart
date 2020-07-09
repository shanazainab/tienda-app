import 'package:equatable/equatable.dart';

class Category extends Equatable {
  int id;
  String nameArabic;
  String nameEnglish;
  String thumbnail;

  List<SubCategory> subCategories;

  Category(
      {this.id,
      this.nameArabic,
      this.nameEnglish,
      this.thumbnail,
      this.subCategories});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json['name_en'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_ar'] = this.nameArabic;
    data['name_en'] = this.nameEnglish;
    data['thumbnail'] = this.thumbnail;
    return data;
  }

  @override
  // TODO: implement stringify
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object> get props => [nameEnglish];
}

class SubCategory {
  String id;
  String nameEnglish;
  String nameArabic;

  SubCategory({this.id, this.nameEnglish, this.nameArabic});
}
