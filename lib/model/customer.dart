// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

import 'package:tienda/model/presenter.dart';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer(
      {this.id,
      this.fullName,
      this.phoneNumber,
      this.email,
      this.dob,
      this.referral,
      this.profilePicture,
      this.points,
      this.following,
      this.followedPresenters,
      this.membershipType});

  int id;
  String fullName;
  String phoneNumber;
  String email;
  DateTime dob;
  String referral;
  String profilePicture;
  int points;
  int following;
  String membershipType;
  List<Presenter> followedPresenters;

  factory Customer.fromJson(Map<String, dynamic> json) {
    // "membership": "regular",
    return Customer(
        id: json["id"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        dob: json["dob"] != null ? DateTime.parse(json["dob"]) : null,
        referral: json["referral"],
        profilePicture: json["profile_picture"],
        points: json["points"],
        following: json["following"],
        membershipType: json['membership'],
        followedPresenters: json["followed_presenters"] != null
            ? List<Presenter>.from(
                json["followed_presenters"].map((x) => Presenter.fromJson(x)))
            : null);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "email": email,
        "membership": membershipType,
        //  "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "referral": referral,
        "profile_picture": profilePicture,
        "points": points,
        "following": following,
        //  "followed_presenters": List<dynamic>.from(followedPresenters.map((x) => x.toJson())),
      };
}
