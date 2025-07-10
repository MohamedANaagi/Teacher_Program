import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:html' as html;

import 'code_state.dart';
import 'code_event.dart';

class CodeBloc extends Bloc<CodeEvent, CodeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CodeBloc() : super(CodeInitial()) {
    on<ValidateCode>(_onValidateCode);
  }

  Future<void> _onValidateCode(
    ValidateCode event,
    Emitter<CodeState> emit,
  ) async {
    emit(CodeLoading());
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('id', isEqualTo: event.code)
          .get();

      if (querySnapshot.docs.isEmpty) {
        emit(CodeError('الكود غير صحيح'));
        return;
      }

      final doc = querySnapshot.docs.first;
      if (!doc.exists) {
        emit(CodeError('الكود غير صحيح'));
        return;
      }

      final courses = List<String>.from(doc['courses'] ?? []);
      if (!courses.contains(event.courseName)) {
        emit(CodeError('هذا الكود غير صالح لهذه الدورة'));
        return;
      }

      final isUsed = doc['isUsed'] ?? false;
      if (isUsed) {
        emit(CodeError('هذا الكود مستخدم من قبل'));
        return;
      }

      await doc.reference.update({'isUsed': true});
      html.window.localStorage['isRegistered_${event.courseName}'] = 'true';

      emit(CodeValid(courseName: event.courseName));
    } catch (e) {
      emit(CodeError('حدث خطأ أثناء التحقق'));
    }
  }
}
