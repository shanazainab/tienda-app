import 'dart:convert';

List<PaymentCard> paymentCardFromJson(String str) => List<PaymentCard>.from(
    json.decode(str).map((x) => PaymentCard.fromJson(x)));

String paymentCardToJson(List<PaymentCard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentCard {
  PaymentCard({
    this.type,
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.name,
    this.cvv,
    this.bankName,
    this.email,
    this.lastDigits,
    this.cardScheme,
    this.cardType,
    this.id,
  });

  String lastDigits;
  String cardScheme;
  String cardType;
  int id;

  String type;
  String email;
  String number;
  String expiryMonth;
  String expiryYear;
  String name;
  String cvv;
  String bankName;

  factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
        type: json["type"],
        number: json["number"],
        expiryMonth: json["expiry_month"],
        expiryYear: json["expiry_year"],
        name: json["name"],
        bankName: json["bank_name"],
        cvv: json["cvv"],
        email: json['email'],
        lastDigits: json["last_digits"],
        cardScheme: json["card_scheme"],
        cardType: json["card_type"],
        id: json["id"],
      );

  @override
  String toString() {
    return 'PaymentCard{lastDigits: $lastDigits, cardScheme: $cardScheme, cardType: $cardType, id: $id, type: $type, email: $email, number: $number, expiryMonth: $expiryMonth, expiryYear: $expiryYear, name: $name, cvv: $cvv, bankName: $bankName}';
  }

  Map<String, dynamic> toJson() => {
        if (type != null) "type": type,
        if (number != null) "number": number,
        if (expiryMonth != null) "expiry_month": expiryMonth,
        if (expiryYear != null) "expiry_year": expiryYear,
        if (bankName != null) "bank_name": bankName,
        if (name != null) "name": name,
        if (cvv != null) "cvv": cvv,
        if (email != null) "email": email,
        if (lastDigits != null) "last_digits": lastDigits,
        if (cardScheme != null) "card_scheme": cardScheme,
        if (cardType != null) "card_type": cardType,
        if (id != null) "id": id,
      };
}
