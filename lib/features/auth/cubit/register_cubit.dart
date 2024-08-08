import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void checkBox(bool value) {
    final initialState = (state as RegisterInitial);
    emit(initialState.copyWith(isChecked: value));
  }

  void showHidePassword() {
    final initialState = (state as RegisterInitial);
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
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void register({required String email, required String password}) async {
    final initialState = (state as RegisterInitial);

    if (initialState.formkey.currentState!.validate() &&
        initialState.isChecked) {
      initialState.formkey.currentState!.save();
      try {
        final createdUser = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final UserModel newUser = UserModel(email: email, points: 0);

        final users = _firestore.collection("User").doc(createdUser.user!.uid);

        // Add User to Database
        users.set(newUser.toJson());
        users.collection("MessageTo").doc("initial").set({"messageTo": []});
        users.collection("MessageFrom").doc("initial").set({"messageFrom": []});

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
