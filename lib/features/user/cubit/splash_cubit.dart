import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit()
      : super(
          SplashState(
            isRemembered: false,
          ),
        ) {
    _isUserRemembered();
  }

  void _isUserRemembered() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isRemembered = prefs.getBool("isRemembered");
    final String? password = prefs.getString("password");
    final String? email = prefs.getString("email");
    if (isRemembered == true) {
      auth.signInWithEmailAndPassword(email: email!, password: password!);
      final users = firestore.collection("User").doc(auth.currentUser!.uid);

      users.update({
        "isActive": true,
      });
      Future.delayed(
        const Duration(seconds: 2),
        () {
          emit(SplashState(isRemembered: true));
        },
      );
    } else {
      emit(SplashState(isRemembered: false));
    }
  }
}
