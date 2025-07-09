// lib/screens/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configure/navigation_service.dart';
import '../cubits/registration_cubit.dart';

class RegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            Navigator.pushReplacementNamed(context, '/courses');
          }
          if (state is RegistrationNavigateToCourses) {
            locator<NavigationService>().navigateToReplacement('/courses');
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(labelText: 'الكود'),
                    validator: (value) =>
                        value!.isEmpty ? 'يجب إدخال الكود' : null,
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<RegistrationCubit, RegistrationState>(
                    builder: (context, state) {
                      if (state is RegistrationLoading) {
                        return CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<RegistrationCubit>()
                                .submitCode(_codeController.text);
                          }
                        },
                        child: Text('تسجيل الدخول'),
                      );
                    },
                  ),
                  // if (state is RegistrationError)
                  //   Text(
                  //     state.message,
                  //     style: TextStyle(color: Colors.red),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
