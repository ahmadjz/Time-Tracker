import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog(
      {super.key, required String title, required FirebaseException exception})
      : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );
  static String _message(FirebaseException exception) {
    print(exception);
    print(exception.code);
    return _errors[exception.code].toString();
  }

  static final Map<String, String> _errors = {
    'wrong-password': 'The password is invalid',
    'invalid-email': 'The email is invalid',
    'permission-denied': 'Missing or insufficient permission',
  };
}
