import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool SisLogin = false;

  bool get isLogin => SisLogin;

  Stream<User?> streamAuthStatus() {
    return _auth.authStateChanges();
  }

  static Future<String> getFirebaseMessage () async {
    await fMessaging.requestPermission();
    var token;
    await fMessaging.getToken().then((t) {
      log("token firebase: $t");
      
      token = t;
    });
    return token;
  }

  Future<bool> login(String email, String password) async{
    try {
      log("Hello");
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      SisLogin = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        return false;
      }
    }

    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    SisLogin = false;
  }



}