import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogService extends ChangeNotifier {
  final CollectionReference _logsCollection =
      FirebaseFirestore.instance.collection('logs');

  // Fonction pour enregistrer une action dans les logs
  Future<void> logAction({
    required String action,
    required String details,
    required String userId,
    required String role,
   // Utilisateur cible
  }) async {
    try {
      await _logsCollection.add({
        'action': action,
        'details': details,
        'userId': userId, // Celui qui effectue l'action
         // Celui qui est affecté par l'action
        'role': role, // Rôle passé en paramètre
        'timestamp': FieldValue.serverTimestamp(), // Timestamp actuel
      });
    } catch (e) {
      print("Erreur lors de l'enregistrement des logs : $e");
    }
  }

  // Stream pour récupérer les logs avec pagination
  Stream<QuerySnapshot> getLogsStream({DocumentSnapshot? lastLog}) {
    Query query =
        _logsCollection.orderBy('timestamp', descending: true).limit(20);
    if (lastLog != null) {
      query = query.startAfterDocument(lastLog);
    }
    return query.snapshots();
  }
}
