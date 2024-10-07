import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  // Convertir un User Firebase en UserModel
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
    );
  }
}
