import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir tous les utilisateurs
  Stream<List<Map<String, dynamic>>> getUsers() {
    return _usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
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
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur : $e');
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      notifyListeners();
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
          .where('role', isEqualTo: 'personnel')
          .where('chefId', isEqualTo: chefId)
          .get();

      // Retourne une liste des données des personnels
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc
              .id, // Récupère l'ID du document comme identifiant du personnel
          'nom': doc['nom'] ?? 'Nom inconnu',
          'email': doc['email'] ?? 'Email non disponible',
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
}
