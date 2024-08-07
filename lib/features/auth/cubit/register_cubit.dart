import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/model/user_model.dart';
import 'package:flutter/material.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit()
      : super(
          RegisterInitial(
            isChecked: false,
            isObsecured: true,
            formkey: GlobalKey<FormState>(),
            isError: false,
          ),
        );
  void checkBox(bool value) {
    final initialState = (state as RegisterInitial);
    emit(initialState.copyWith(isChecked: value));
  }

  void showHidePassword() {
    final initialState = (state as RegisterInitial);
    emit(initialState.copyWith(isObsecured: !initialState.isObsecured));
  }

  void register({required String email, required String password}) async {
    final initialState = (state as RegisterInitial);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    if (initialState.formkey.currentState!.validate() &&
        initialState.isChecked) {
      initialState.formkey.currentState!.save();
      try {
        final createdUser = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        UserModel newUser = UserModel(email: email, points: 0);

        final users = firestore.collection("User").doc(createdUser.user!.uid);

        // Add User to Database
        users.set(newUser.toJson());

        initialState.formkey.currentState!.reset();
        emit(RegisterSuccess(message: "Success"));
      } on FirebaseAuthException catch (e) {
        emit(RegisterError(message: e.message.toString()));
      }
    }
    emit(initialState.copyWith());
  }

  void initializeState() {
    emit(
      RegisterInitial(
        isChecked: false,
        isObsecured: true,
        formkey: GlobalKey<FormState>(),
        isError: false,
      ),
    );
  }
}
