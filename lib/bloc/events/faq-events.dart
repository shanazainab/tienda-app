import 'package:equatable/equatable.dart';

abstract class FAQEvents extends Equatable {
  FAQEvents();

  @override
  List<Object> get props => null;
}

class LoadReferralQuestions extends FAQEvents {
  LoadReferralQuestions() : super();

  @override
  List<Object> get props => [];
}

class LoadGeneralQuestions extends FAQEvents {
  LoadGeneralQuestions() : super();

  @override
  List<Object> get props => [];
}
