// bloc/code_state.dart

import 'package:equatable/equatable.dart';

abstract class CodeState extends Equatable {
  const CodeState();

  @override
  List<Object> get props => [];
}

class CodeInitial extends CodeState {}

class CodeLoading extends CodeState {}

class CodeValid extends CodeState {
  final String courseName;
  const CodeValid({required this.courseName});
}

class CodeError extends CodeState {
  final String message;
  const CodeError(this.message);
}
