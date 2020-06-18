class Category {
    int id;
    String nameArabic;
    String nameEnglish;
    String thumbnail;

    Category({this.id, this.nameArabic, this.nameEnglish, this.thumbnail});

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
}