import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer le nombre total de personnel dans une localité donnée
  Future<int> getTotalPersonnelByLocalite(String localite) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'personnel')
          .where('localite', isEqualTo: localite)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération du nombre de personnels : $e');
      return 0;
    }
  }

  // Récupérer le nombre total de demandeurs dans une localité donnée
  Future<int> getTotalDemandeursByLocalite(String localite) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'demandeur')
          .where('localite', isEqualTo: localite)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération du nombre de demandeurs : $e');
      return 0;
    }
  }

  // Récupérer le nombre total de demandes dans une localité donnée
  Future<int> getTotalDemandesByLocalite(String localite) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('demandes')
          .where('localite', isEqualTo: localite)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération du nombre de demandes : $e');
      return 0;
    }
  }

  // Récupérer le nombre total de demandes assignées dans une localité donnée
  Future<int> getTotalDemandesAssignees(String localite) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('demandes')
          .where('localite', isEqualTo: localite)
          .where('assigneA', isNotEqualTo: null)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des demandes assignées : $e');
      return 0;
    }
  }

  // Récupérer le nombre total de demandes par statut dans une localité donnée
  Future<int> getTotalDemandesByStatut(String statut, String localite) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('demandes')
          .where('localite', isEqualTo: localite)
          .where('statut', isEqualTo: statut)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des demandes par statut : $e');
      return 0;
    }
  }

  // Récupérer les performances du personnel dans une localité donnée
  Future<List<PersonnelPerformance>> getPersonnelPerformanceByLocalite(
      String localite) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('demandes')
          .where('localite', isEqualTo: localite)
          .where('assigneA', isNotEqualTo: null)
          .get();

      // Création d'une map pour stocker le nombre de demandes traitées par personnel
      Map<String, int> performanceMap = {};

      for (var doc in snapshot.docs) {
        String? personnelId = doc['assigneA'];
        if (personnelId != null) {
          performanceMap[personnelId] = (performanceMap[personnelId] ?? 0) + 1;
        }
      }

      // Récupérer les noms des personnels à partir des IDs
      List<PersonnelPerformance> performances = [];
      for (String personnelId in performanceMap.keys) {
        DocumentSnapshot personnelDoc =
            await _firestore.collection('users').doc(personnelId).get();
        String personnelName = personnelDoc['nom'] ?? 'Inconnu';

        performances.add(
            PersonnelPerformance(personnelName, performanceMap[personnelId]!));
      }

      return performances;
    } catch (e) {
      print(
          'Erreur lors de la récupération des performances du personnel : $e');
      return [];
    }
  }
}

// Modèle pour les performances du personnel
class PersonnelPerformance {
  final String personnelName;
  final int demandesTraitees;

  PersonnelPerformance(this.personnelName, this.demandesTraitees);
}
