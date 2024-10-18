import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:terrain/services/hist_service.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;    

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final LogService _logService = LogService();

  // Obtenir tous les utilisateurs
  Stream<List<Map<String, dynamic>>> getUsers() {
    return _usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getUsersData() async {
    try {
      // Récupération des documents depuis la collection "users"
      QuerySnapshot querySnapshot = await _usersCollection.get();

      // Mapping des données pour les renvoyer sous forme de liste de Map
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Assurez-vous d'avoir l'ID du document
          ...doc.data()
              as Map<String, dynamic> // Les autres données de l'utilisateur
        };
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs: $e');
      return [];
    }
  }


  // Récupérer les informations de l'utilisateur connecté
  // Récupérer le rôle de l'utilisateur connecté
  Future<String?> getUserRole() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data()?['role'] as String?;
    }
    return null;
  }

Future<void> saveUserToken(String userId) async {
    // Obtenir le token de l'appareil de l'utilisateur
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      // Sauvegarder le token dans Firestore ou dans une base de données appropriée
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'token': token,
      });
    }
  }

  // Ajouter un DEMANDEUR (lui-même) à Firestore après l'inscription
  Future<void> addDemandeur({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String adresse,
  }) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Ajouter dans Firestore
        await _usersCollection.doc(currentUser.uid).set({
          'email': email,
          'role': 'demandeur',
          'nom': nom,
          'prenom': prenom,
          'adresse': adresse,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("Demandeur ajouté avec succès dans Firestore.");
      }
    } catch (e) {
      print("Erreur lors de l'ajout du demandeur dans Firestore : $e");
      throw Exception(
          "Erreur lors de l'ajout du demandeur dans Firestore : $e");
    }
  }

  // Ajouter un CHEF DE PERSONNEL (par admin)
  Future<void> addChefPersonnel({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String adresse,
    required String localite,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user!;

      // Ajouter dans Firestore
      await _usersCollection.doc(user.uid).set({
        'email': email,
        'role': 'chef_personnel',
        'nom': nom,
        'prenom': prenom,
        'adresse': adresse,
        'localite': localite,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("Chef de personnel ajouté avec succès.");
    } catch (e) {
      print("Erreur lors de l'ajout du chef de personnel : $e");
      throw Exception("Erreur lors de l'ajout du chef de personnel : $e");
    }
  }

  // Ajouter un PERSONNEL (par chef de personnel)
  Future<void> addPersonnel({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String adresse,
    required String localite,
    required String chefId,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user!;

      // Ajouter dans Firestore
      await _usersCollection.doc(user.uid).set({
        'email': email,
        'role': 'personnel',
        'nom': nom,
        'prenom': prenom,
        'adresse': adresse,
        'localite': localite,
        'chefId': chefId,
        'createdAt': FieldValue.serverTimestamp(),
      });
notifyListeners();
      print("Personnel ajouté avec succès.");
    } catch (e) {
      print("Erreur lors de l'ajout du personnel : $e");
      throw Exception("Erreur lors de l'ajout du personnel : $e");
    }
  }

  // Mettre à jour un utilisateur
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(userId).update(userData);
      notifyListeners();
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur : $e');
    }
  }

  // Supprimer un utilisateur
 // Suppression d'un utilisateur avec logs
  Future<void> deleteUser(String userId) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      // Avant suppression, récupérer les informations de l'utilisateur supprimé
      final Map<String, dynamic>? userToDelete = await getUserById(userId);

      if (userToDelete != null && currentUser != null) {
        await _usersCollection.doc(userId).delete();

       

        notifyListeners();
        print("Utilisateur supprimé avec succès.");
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur : $e');
    }
  }


  // Obtenir la localité d'un chef de personnel
  Future<String?> getLocaliteByRole(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _usersCollection.doc(userId).get();

      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!['role'] == 'chef_personnel') {
        return userDoc.data()!['localite'] as String?;
      }
      return null;
      
    } catch (e) {
      print("Erreur lors de la récupération de la localité : $e");
      throw Exception("Erreur lors de la récupération de la localité : $e");
    }
  }

  // Obtenir tout le personnel dans une localité spécifique
  Stream<List<Map<String, dynamic>>> getPersonnelByLocalite(String localite) {
    return _usersCollection
        .where('role', isEqualTo: 'personnel')
        .where('localite', isEqualTo: localite)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

Future<List<Map<String, dynamic>>> getPersonnelsByChef(String chefId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'personnel') // Filtrer par rôle 'personnel'
          .where('chefId', isEqualTo: chefId) // Filtrer par chefId
          .get();

      // Retourne une liste des données des personnels avec tous les champs nécessaires
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Récupère l'ID du document
          'nom': doc['nom'] ?? 'Nom inconnu',
          'prenom': doc['prenom'] ?? 'Prénom non disponible',
          'email': doc['email'] ?? 'Email non disponible',
          'adresse': doc['adresse'] ?? 'Adresse non disponible',
          'localite': doc['localite'] ?? 'Localité non disponible',
          'role': doc['role'] ?? 'Rôle non disponible',
        };
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des personnels : $e");
      return [];
    }
  }



    // Méthode pour obtenir un utilisateur via son ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _usersCollection.doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data(); // Retourne les données de l'utilisateur
      }
      return null; // Retourne null si l'utilisateur n'existe pas
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      return null;
    }
  }
  // Ajoute cette méthode pour récupérer le nombre total d'utilisateurs
  Future<int> getUsersCount() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return querySnapshot
          .size; // Retourne le nombre de documents (utilisateurs)
    } catch (e) {
      print("Erreur lors de la récupération du nombre d'utilisateurs : $e");
      return 0;
    }
  }
    // Récupérer le nombre de nouveaux utilisateurs ce mois-ci
  Future<int> getNouveauxUtilisateursCeMois() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);

      QuerySnapshot snapshot = await _usersCollection
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des nouveaux utilisateurs: $e');
      return 0;
    }
  }
}

