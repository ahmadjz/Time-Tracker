import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;

  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(
      EmailSignInModel()); // seeded is for initial value

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  // EmailSignInModel _model = EmailSignInModel(); // we don't need to keep track of data locally
  EmailSignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      bool? submitted}) {
    // update model
    _modelSubject.add(_model.copyWith(
        email: email,
        formType: formType,
        isLoading: isLoading,
        password: password,
        submitted: submitted));
    // another syntax
    // _modelSubject.value = _model.copyWith(
    //   email: email,
    //   password: password,
    //   formType: formType,
    //   isLoading: isLoading,
    //   submitted: submitted,
    // );
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(
          isLoading:
              false); // we don't need to set false if signIn is success because we replace the page with the home page
      rethrow;
    } finally {}
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      submitted: false,
      formType: formType,
      email: '',
      password: '',
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
}
