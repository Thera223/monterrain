import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConseilService extends ChangeNotifier {
  final CollectionReference assistantsCollection =
      FirebaseFirestore.instance.collection('assistants');

  // Fonction pour récupérer tous les assistants
  Future<List<Map<String, dynamic>>> getAllAssistants() async {
    try {
      QuerySnapshot querySnapshot = await assistantsCollection.get();
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'nom': doc['name'] ?? 'Nom inconnu',
          'adresse': doc['adresse'] ?? 'Adresse inconnue',
          'contact': doc['contact'] ?? 'Contact inconnu',
          'popularity': doc['popularity'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des assistants: $e");
      return [];
    }
  }
}
