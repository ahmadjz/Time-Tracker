import 'dart:async';

import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});

  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<UserModel?> _signIn(Future<UserModel?> Function() signInMethod) async {
    // This function is for reducing the duplicated code between 3 sign in methods and we use only on instead and we pass the different part as a function
    // and this function returns type Future UserModel
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(
          false); // we don't need to set false if signIn is success because we replace the page with the home page
      rethrow;
    } finally {}
  }

  Future<UserModel?> signInAnonymously() async =>
      await _signIn(() => auth.signInAnonymously());
}
