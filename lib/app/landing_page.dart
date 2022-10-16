import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/home_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/Auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserModel? user = snapshot.data;
            if (user == null) {
              return SignInPage(
                auth: auth,
              );
            }
            return HomePage(
              auth: auth,
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
