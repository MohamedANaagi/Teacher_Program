// lib/cubits/registration/registration_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/firestore_services.dart';
import '../services/shared_prefrences_services.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final FirestoreService firestoreService;
  final LocalCache localCache;

  RegistrationCubit({required this.firestoreService, required this.localCache})
      : super(RegistrationInitial());

  void submitCode(String code) async {
    emit(RegistrationLoading());
    try {
      final isValid = await firestoreService.validateCode(code);
      if (isValid) {
        await localCache.setRegistered();
        emit(RegistrationNavigateToCourses()); // حالة خاصة للانتقال

        emit(RegistrationSuccess());
      } else {
        emit(RegistrationError('الكود غير صالح أو مستخدم مسبقًا'));
      }
    } catch (e) {
      emit(RegistrationError(e.toString()));
    }
  }
}

// registration_state.dart

abstract class RegistrationState extends Equatable {
  const RegistrationState();
  @override
  List<Object> get props => [];
}

class RegistrationNavigateToCourses extends RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationError extends RegistrationState {
  final String message;
  const RegistrationError(this.message);
}
