// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.dob,
    this.referral,
    this.profilePicture,
    this.points,
    this.following,
    this.followedPresenters,
  });

  int id;
  String fullName;
  String phoneNumber;
  String email;
  DateTime dob;
  String referral;
  String profilePicture;
  int points;
  int following;
  List<FollowedPresenter> followedPresenters;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    email: json["email"],
    dob: DateTime.parse(json["dob"]),
    referral: json["referral"],
    profilePicture: json["profile_picture"],
    points: json["points"],
    following: json["following"],
    followedPresenters: List<FollowedPresenter>.from(json["followed_presenters"].map((x) => FollowedPresenter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "email": email,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "referral": referral,
    "profile_picture": profilePicture,
    "points": points,
    "following": following,
    "followed_presenters": List<dynamic>.from(followedPresenters.map((x) => x.toJson())),
  };
}

class FollowedPresenter {
  FollowedPresenter({
    this.name,
    this.bio,
    this.id,
    this.isLive,
    this.profilePicture,
  });

  String name;
  String bio;
  int id;
  bool isLive;
  String profilePicture;

  factory FollowedPresenter.fromJson(Map<String, dynamic> json) => FollowedPresenter(
    name: json["name"],
    bio: json["bio"],
    id: json["id"],
    isLive: json["is_live"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "bio": bio,
    "id": id,
    "is_live": isLive,
    "profile_picture": profilePicture,
  };
}
