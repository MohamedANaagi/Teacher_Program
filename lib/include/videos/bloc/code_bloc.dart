import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          .where('code', isEqualTo: event.code)
          .get();

      if (querySnapshot.docs.isEmpty || !querySnapshot.docs.first.exists) {
        emit(CodeError('الكود غير صحيح'));
        return;
      }

      final doc = querySnapshot.docs.first;
      final courses = Map<String, bool>.from(doc['courses'] ?? {});

      if (!courses.containsKey(event.courseName)) {
        emit(CodeError('هذا الكود غير صالح لهذه الدورة'));
        return;
      }

      if (courses[event.courseName]!) {
        emit(CodeError('هذا الكود مستخدم بالفعل لهذه الدورة'));
        return;
      }

      // Update only the specific course's usage flag
      await doc.reference.update({
        'courses.${event.courseName}': true,
      });

      html.window.localStorage['isRegistered_${event.courseName}'] = 'true';
      emit(CodeValid(courseName: event.courseName));
    } catch (e) {
      emit(CodeError('حدث خطأ أثناء التحقق: ${e.toString()}'));
    }
  }
}
