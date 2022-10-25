import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:time_tracker/services/auth.dart';

class SignInManger {
  SignInManger({required this.isLoading, required this.auth});

  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  final ValueNotifier<bool> isLoading;

  Future<UserModel?> _signIn(Future<UserModel?> Function() signInMethod) async {
    // This function is for reducing the duplicated code between 3 sign in methods and we use only on instead and we pass the different part as a function
    // and this function returns type Future UserModel
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    } finally {}
  }

  Future<UserModel?> signInAnonymously() async =>
      await _signIn(() => auth.signInAnonymously());
}
