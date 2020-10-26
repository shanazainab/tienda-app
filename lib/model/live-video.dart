import 'package:logger/logger.dart';
import 'package:tienda/model/presenter.dart';

class LiveVideo {
  LiveVideo(
      {this.id,
      this.programTitle,
      this.liveTime,
      this.thumbnail,
      this.isLive,
      this.isFeatured,
      this.viewersCount,
      this.commentCount,
      this.shortDescription,
      this.presenter});

  int id;
  String programTitle;
  DateTime liveTime;
  String thumbnail;
  bool isLive;
  String shortDescription;
  String viewersCount;
  int commentCount;

  bool isFeatured;
  Presenter presenter;

  /// [{"id": 1, "presenter_id": 10, "program_title": "All About Hivebox Freezer", "live_time": "2020-10-23T10:17:00Z", "thumbnail": "live_streams/thumbnails/shutterstock_1449672308_1_6.png", "is_live": true, "is_featured": false, "short_description": "Bella describes what fuels her passion. Salt enhances dishes, pepper changes them.", "presenter": {"id": 10, "name": "Bella", "profile_picture": "Bella.png", "followers": 2, "stream_url": "rtmp://45.77.27.157:1935/live/bella", "m3u8_url": "https://5f79325e33ce3.streamlock.net/live/bella/playlist.m3u8"}}]

  /// "viewers_count": "1", "comments": 2

  factory LiveVideo.fromJson(Map<String, dynamic> json) {
    LiveVideo liveContent;
    try {
      liveContent = LiveVideo(
          id: json["id"],
          programTitle: json["program_title"],
          liveTime: DateTime.parse(json["live_time"]),
          thumbnail: json["thumbnail"],
          commentCount: json['comments'],
          viewersCount: json['viewers_count'],
          shortDescription: json["short_description"],
          isFeatured: json["is_featured"],
          isLive: json["is_live"],
          presenter: Presenter.fromJson(json['presenter']));
    } catch (e) {
      Logger().e(e);
    }
    return liveContent;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "program_title": programTitle,
        "viewers_count": viewersCount,
        "comments": commentCount,
        "live_time": liveTime.toIso8601String(),
        "thumbnail": thumbnail,
        "is_live": isLive,
        "presenter": presenter.toJson(),
        "is_featured": isFeatured,
        "short_description": shortDescription
      };
}
