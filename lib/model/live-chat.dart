///{body: test message, room_name: PR-10, sent_at: 1597577500719,
///sender_name: Shahana, sender_profile: /media/user_profile/2020-08-09_083330.497985_50.jpeg}
///

class LiveChat {
  String senderName;
  String profileImageUrl;
  int dateTime;
  String body;
  bool isPremium;

  LiveChat(this.body,this.senderName, this.profileImageUrl, this.dateTime,this.isPremium);
}
