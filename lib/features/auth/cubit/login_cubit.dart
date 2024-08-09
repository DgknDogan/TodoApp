import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/data/enums/auth_error_codes_enum.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user/model/user_model.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : super(
          LoginInitial(
            formKey: GlobalKey<FormState>(),
            isObsecured: true,
            isRemembered: false,
          ),
        );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showHidePassword() {
    final initialState = (state as LoginInitial);
    emit(initialState.copyWith(isObsecured: !initialState.isObsecured));
  }

  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(cred);
      if (_auth.currentUser != null) {
        _firestore.collection("User").doc(_auth.currentUser!.uid).update(
          {"isActive": true},
        );
      }

      final querySnapshot = await _firestore.collection("User").get();

      final List<String> idList = [];
      for (var doc in querySnapshot.docs) {
        idList.add(doc.id);
      }

      if (!idList.contains(_auth.currentUser!.uid)) {
        final UserModel newUser = UserModel(
          points: 0,
          email: _auth.currentUser!.email,
          name: _auth.currentUser!.displayName,
        );

        final users = _firestore.collection("User").doc(_auth.currentUser!.uid);
        users.set(newUser.toJson());
        users.collection("MessageTo").doc("initial").set({"messageTo": []});
        users.collection("MessageFrom").doc("initial").set({"messageFrom": []});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Login with email and password
  void login({required String email, required String password}) async {
    final initialState = (state as LoginInitial);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (initialState.formKey.currentState!.validate()) {
      initialState.formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final users = _firestore.collection("User").doc(_auth.currentUser!.uid);

        users.update({
          "isActive": true,
          "isRemembered": initialState.isRemembered,
        });

        await prefs.setBool("isRemembered", initialState.isRemembered);
        await prefs.setString("password", password);
        await prefs.setString("email", email);

        initialState.formKey.currentState!.reset();
        emit(LoginSuccess(message: "success"));
      } on FirebaseAuthException catch (e) {
        if (e.code == AuthErrorCodes.networkError.code) {
          emit(LoginFailed(message: AuthErrorCodes.networkError.message));
        } else if (e.code == AuthErrorCodes.invalidEmail.code) {
          emit(LoginFailed(message: AuthErrorCodes.invalidEmail.message));
        } else if (e.code == AuthErrorCodes.userDisabled.code) {
          emit(LoginFailed(message: AuthErrorCodes.userDisabled.message));
        } else if (e.code == AuthErrorCodes.userNotFound.code) {
          emit(LoginFailed(message: AuthErrorCodes.userNotFound.message));
        } else if (e.code == AuthErrorCodes.wrongPassword.code) {
          emit(LoginFailed(message: AuthErrorCodes.wrongPassword.message));
        } else {
          emit(LoginFailed(message: e.message.toString()));
        }
      }
    }
    emit(initialState.copyWith());
  }

  void checkBox(bool value) {
    final initialState = (state as LoginInitial);
    emit(initialState.copyWith(isRemembered: value));
  }

  void initializeState() {
    emit(
      LoginInitial(
        isObsecured: true,
        formKey: GlobalKey<FormState>(),
        isRemembered: false,
      ),
    );
  }
}
