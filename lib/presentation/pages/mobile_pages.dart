import 'package:catatan/presentation/controller/auth_controller.dart';
import 'package:catatan/presentation/pages/homepage/mobile/mobile_home.dart';
import 'package:catatan/presentation/pages/login/mobile/mobile_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class MobileMain extends StatelessWidget {
  MobileMain({super.key});

  final authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // initialData: FirebaseAuth.instance.currentUser,
      // initialData: null,
      stream: authC.streamAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          return (snapshot.data != null) ? 
          MaterialApp(
            theme: ThemeData(
              androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
            ),
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) {
                // return PinWidget(user: snapshot);
                
                return MobileHome(user: snapshot);
              }
            ),
          )
          :
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) {
                return const MobileLogin();
              }
            ),
          );
        }
        
      });
  }
}