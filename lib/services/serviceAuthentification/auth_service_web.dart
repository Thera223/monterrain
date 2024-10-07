import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:terrain/services/serviceAuthentification/auth_service.dart';

class AuthServiceWeb extends AuthServiceInterface {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String _defaultAdminEmail = 'admin@system.com';
  final String _defaultAdminPassword = 'admin1234';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> initializeAdminAccount() async {
    try {
      // Vérifier si l'email admin existe dans Firebase Auth
      List<String> methods =
          await _firebaseAuth.fetchSignInMethodsForEmail(_defaultAdminEmail);

      User? adminUser;

      if (methods.isEmpty) {
        // Si l'email n'existe pas, créer le compte admin
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: _defaultAdminEmail,
          password: _defaultAdminPassword,
        );
        adminUser = userCredential.user!;
        print("Compte admin créé dans Firebase Auth.");
      } else {
        // Si l'email existe déjà, se connecter avec le compte existant
        UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: _defaultAdminEmail,
          password: _defaultAdminPassword,
        );
        adminUser = userCredential.user!;
        print("Compte admin existant dans Firebase Auth.");
      }

      // Vérifier si l'utilisateur existe déjà dans Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(adminUser.uid).get();

      if (!userDoc.exists) {
        // Ajouter le compte admin à Firestore s'il n'existe pas encore
        await _firestore.collection('users').doc(adminUser.uid).set({
          'email': _defaultAdminEmail,
          'role': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("Compte admin ajouté dans Firestore.");
      } else {
        print("Compte admin déjà existant dans Firestore.");
      }
    } catch (e) {
      print("Erreur lors de l'initialisation du compte admin : $e");
    }
  }

  @override
  Future<User?> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = result.user!;

      // Obtenir les données utilisateur dans Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Si l'utilisateur n'existe pas dans Firestore, afficher une erreur
        _showErrorDialog(context, 'Utilisateur non trouvé dans Firestore');
        return null;
      }

      String role = userDoc['role'];

      // Redirection selon le rôle de l'utilisateur
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else if (role == 'chef_personnel') {
        Navigator.pushReplacementNamed(context, '/chef-dashboard', arguments: {
          'localite': userDoc['localite'] ?? 'Non spécifiée'
        }); // Ajouter la localité si chef personnel
      } else if (role == 'personnell') {
        Navigator.pushReplacementNamed(context, '/personnel-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/demandeur-dashboard');
      }

      return user;
    } catch (e) {
      _showErrorDialog(context, 'Erreur de connexion: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> registerWithEmail(
      String email, String password, BuildContext context) {
    throw UnimplementedError("L'inscription n'est pas disponible sur le web.");
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
}
