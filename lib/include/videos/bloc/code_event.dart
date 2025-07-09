// bloc/code_event.dart
import 'package:equatable/equatable.dart';

abstract class CodeEvent extends Equatable {
  const CodeEvent();

  @override
  List<Object> get props => [];
}

class ValidateCode extends CodeEvent {
  final String code;
  final String courseName;

  const ValidateCode({required this.code, required this.courseName});

  @override
  List<Object> get props => [code, courseName];
}
