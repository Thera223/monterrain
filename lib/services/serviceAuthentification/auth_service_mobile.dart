import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServiceMobile with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // Retourne l'utilisateur inscrit
    } on FirebaseAuthException catch (e) {
      String errorMessage = _translateError(e.code); // Traduction de l'erreur
      _showErrorDialog(context, errorMessage);
      return null; // Retourne null en cas d'échec
    }
  }

  String _translateError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Cette adresse e-mail est déjà utilisée.';
      case 'invalid-email':
        return 'L\'adresse e-mail est invalide.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'operation-not-allowed':
        return 'L\'inscription avec email et mot de passe est désactivée.';
      default:
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }

    // Connexion avec e-mail et mot de passe
 Future<User?> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Une fois connecté, récupérer les informations de l'utilisateur dans Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          final role = userDoc['role'];

          // Ajouter des logs pour vérifier le rôle récupéré
          print("Rôle de l'utilisateur: $role");

          // Redirection en fonction du rôle
          if (role == 'personnel') {
            print("Redirection vers la page du personnel");
            Navigator.pushReplacementNamed(context, '/personnel-mobile');
          } else if (role == 'demandeur') {
            print("Redirection vers la page du demandeur");
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            _showErrorDialog(
              context,
              "Rôle inconnu. Veuillez contacter l'administrateur.",
            );
          }
        } else {
          print("Aucune donnée d'utilisateur trouvée pour cet ID.");
          _showErrorDialog(
              context, "Aucune donnée d'utilisateur trouvée pour cet ID.");
        }
      }
      return user; // Retourne l'utilisateur connecté
    } on FirebaseAuthException catch (e) {
      String errorMessage = _translateErrorr(e.code); // Traduction de l'erreur
      _showErrorDialog(context, errorMessage);
      return null; // Retourne null en cas d'échec
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  String _translateErrorr(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'L\'adresse e-mail est invalide.';
      case 'user-not-found':
        return 'Aucun utilisateur trouvé pour cet e-mail.';
      case 'wrong-password':
        return 'Le mot de passe est incorrect.';
      case 'user-disabled':
        return 'Ce compte utilisateur a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives, veuillez réessayer plus tard.';
      default:
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }
   // Méthode pour récupérer le rôle de l'utilisateur
  Future<String?> getUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists && userDoc.data() != null) {
        return userDoc['role'] as String; // Récupérer le champ 'role'
      } else {
        return null; // Aucun rôle trouvé
      }
    } catch (e) {
      print('Erreur lors de la récupération du rôle utilisateur: $e');
      return null; // En cas d'erreur, retourner null
    }
}
}