import 'package:equatable/equatable.dart';

class Country extends Equatable{
  String countryCode;
  int id;
  String nameArabic;
  String nameEnglish;
  String thumbnail;

  Country(
      {this.countryCode,
      this.id,
      this.nameArabic,
      this.nameEnglish,
      this.thumbnail});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['country_code'],
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json['name_en'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.countryCode;
    data['id'] = this.id;
    data['name_ar'] = this.nameArabic;
    data['name_en'] = this.nameEnglish;
    data['thumbnail'] = this.thumbnail;
    return data;
  }

  @override
  String toString() {
    return 'Country{countryCode: $countryCode, id: $id, nameArabic: $nameArabic, nameEnglish: $nameEnglish, thumbnail: $thumbnail}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [countryCode];
}
