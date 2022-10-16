import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  UserModel({this.photoUrl, this.displayName, required this.uid});
  final String uid;
  final String? photoUrl;
  final String? displayName;
}

abstract class AuthBase {
  Stream<UserModel?> get onAuthStateChanged;
  UserModel? currentUser();
  Future<UserModel?> signInAnonymously();
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
    //another way of writing it map((User)=> _userFromFirebase(firebaseUser
  }

  UserModel? _userFromFirebase(User? user) {
    //this class is for converting from firebase type to my own type
    if (user == null) {
      return null;
    }
    return UserModel(uid: user.uid);
  }

  @override
  UserModel? currentUser() {
    final user = _firebaseAuth.currentUser!;
    return _userFromFirebase(user);
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();

    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
