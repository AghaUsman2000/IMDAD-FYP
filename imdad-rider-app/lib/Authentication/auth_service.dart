import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user;
  }
}
