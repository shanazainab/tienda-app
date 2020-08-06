import 'package:equatable/equatable.dart';
import 'package:tienda/model/faq.dart';

abstract class FAQStates extends Equatable {
  FAQStates();

  @override
  List<Object> get props => null;
}

class Loading extends FAQStates {
  Loading() : super();
}

class LoadReferralQuestionsSuccess extends FAQStates {
  final List<Faq> faqs;

  LoadReferralQuestionsSuccess(this.faqs) : super();

  @override
  List<Object> get props => [faqs];
}
class LoadGeneralQuestionsSuccess extends FAQStates {
  final List<Faq> faqs;

  LoadGeneralQuestionsSuccess(this.faqs) : super();

  @override
  List<Object> get props => [faqs];
}