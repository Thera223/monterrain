import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssistantService extends ChangeNotifier {
  final CollectionReference assistants =
      FirebaseFirestore.instance.collection('assistants');



  // Fonction pour récupérer tous les assistants
  Future<List<Map<String, dynamic>>> getAllAssistants() async {
    try {
      QuerySnapshot querySnapshot = await assistants.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des assistants: $e");
      return [];
    }
  }

  Future<void> deleteAssistant(String id) async {
    try {
      await assistants.doc(id).delete();
      print("Assistant supprimé avec succès.");
    } catch (e) {
      print("Erreur lors de la suppression de l'assistant: $e");
    }
  }

// Mettre à jour un assistant
  Future<void> updateAssistant(String id, String name, String adresse,
      String contact, int popularity) async {
    try {
      await assistants.doc(id).update({
        'name': name,
        'adresse': adresse,
        'contact': contact,
        'popularity': popularity,
      });
      print("Assistant mis à jour avec succès.");
    } catch (e) {
      print("Erreur lors de la mise à jour de l'assistant: $e");
    }
  }
  // Fonction pour ajouter un assistant juridique dans Firestore
  Future<void> addAssistant(
      String name, String adresse, String contact, int popularity) async {
    return assistants
        .add({
          'name': name,
          'adresse': adresse,
          'contact': contact,
          'popularity': popularity,
        })
        .then((value) => print("Assistant ajouté avec succès"))
        .catchError(
            (error) => print("Erreur lors de l'ajout de l'assistant: $error"));
  }


}

