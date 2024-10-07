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
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Récupérer le rôle depuis Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        await _logsCollection.add({
          'userId': currentUser.uid,
          'role': role, // Enregistrer le rôle ici
          'action': action,
          'details': details,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
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
