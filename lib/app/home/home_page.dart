import 'package:flutter/material.dart';
import 'package:time_tracker/services/Auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.auth});
  final AuthBase auth;

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
      ),
    );
  }
}
