import 'package:logger/logger.dart';
import 'package:tienda/model/presenter.dart';

class LiveContent {
  LiveContent(
      {this.id,
      this.programTitle,
      this.liveTime,
      this.thumbnail,
      this.isFeatured,
      this.presenter});

  int id;
  String programTitle;
  DateTime liveTime;
  String thumbnail;

  bool isFeatured;
  Presenter presenter;

  factory LiveContent.fromJson(Map<String, dynamic> json) {
    LiveContent liveContent;
    try {
      liveContent = LiveContent(
          id: json["id"],
          programTitle: json["program_title"],
          liveTime: DateTime.parse(json["live_time"]),
          thumbnail: json["thumbnail"],
          isFeatured: json["is_featured"],
          presenter: Presenter.fromJson(json['presenter']));
    } catch (e) {
      Logger().e(e);
    }
    return liveContent;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "program_title": programTitle,
        "live_time": liveTime.toIso8601String(),
        "thumbnail": thumbnail,
        "presenter": presenter.toJson(),
        "is_featured": isFeatured,
      };
}
