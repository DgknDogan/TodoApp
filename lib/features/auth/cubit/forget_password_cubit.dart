import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit()
      : super(
          ForgetPasswordInitial(
            formKey: GlobalKey<FormState>(),
          ),
        );

  void validateEmail(String email) {
    final initalState = (state as ForgetPasswordInitial);
    if (initalState.formKey.currentState!.validate()) {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.sendPasswordResetEmail(email: email);
      emit(ForgetPasswordSuccess(message: "success"));
    }
    emit(initalState.copyWith());
  }
}
