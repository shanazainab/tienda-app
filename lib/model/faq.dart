class Faq {
  Faq({
    this.id,
    this.questionEn,
    this.answerEn,
    this.questionAr,
    this.answerAr,
    this.type,
  });

  int id;
  String questionEn;
  String answerEn;
  String questionAr;
  String answerAr;
  String type;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    id: json["id"],
    questionEn: json["question_en"],
    answerEn: json["answer_en"],
    questionAr: json["question_ar"],
    answerAr: json["answer_ar"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_en": questionEn,
    "answer_en": answerEn,
    "question_ar": questionAr,
    "answer_ar": answerAr,
    "type": type,
  };
}