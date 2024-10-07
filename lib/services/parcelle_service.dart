import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:terrain/model/demande.dart';
import 'package:terrain/model/parcelle_model.dart';


class ParcelleService extends ChangeNotifier {
  final CollectionReference parcelleCollection =
      FirebaseFirestore.instance.collection('parcelles');
  final CollectionReference demandeCollection =
      FirebaseFirestore.instance.collection('demandes');

  // Ajouter une nouvelle parcelle
  Future<void> addParcelle(Parcelle parcelle) async {
    try {
      await parcelleCollection.add(parcelle.toMap());
      print("Parcelle ajoutée avec succès.");
    } catch (e) {
      print("Erreur lors de l'ajout de la parcelle : $e");
    }
  }


    // Méthode pour modifier une parcelle existante
  Future<void> updateParcelle(Parcelle parcelle) async {
    try {
      await parcelleCollection.doc(parcelle.id).update(parcelle.toMap());
      print("Parcelle mise à jour avec succès.");
    } catch (e) {
      print("Erreur lors de la mise à jour de la parcelle : $e");
    }
  }

  // Récupérer toutes les parcelles
  Future<List<Parcelle>> getAllParcelles() async {
    try {
      QuerySnapshot querySnapshot = await parcelleCollection.get();
      return querySnapshot.docs
          .map((doc) =>
              Parcelle.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des parcelles : $e");
      return [];
    }
  }

  // Supprimer une parcelle par son ID
  Future<void> deleteParcelle(String parcelleId) async {
    try {
      await parcelleCollection.doc(parcelleId).delete();
      print("Parcelle supprimée avec succès.");
    } catch (e) {
      print("Erreur lors de la suppression de la parcelle : $e");
    }
  }

    // Récupérer une parcelle par son numéro
  // Méthode pour récupérer les demandes par numéro de parcelle
  Future<List<Demande>> getDemandesByParcelle(String numParcelle) async {
    try {
      QuerySnapshot querySnapshot = await demandeCollection
          .where('numParcelleOuTitre', isEqualTo: numParcelle)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("Aucune demande trouvée pour la parcelle $numParcelle.");
        return [];
      }

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Demande.fromMap(doc.id, data);
      }).toList();
    } catch (e) {
      print(
          "Erreur lors de la récupération des demandes pour la parcelle $numParcelle : $e");
      return [];
    }
  }

    Future<Map<String, dynamic>?> getParcelleByNumero(int numParcelle) async {
    try {
      // Recherche avec un entier pour numParcelleOuTitre
      QuerySnapshot querySnapshot = await parcelleCollection
          .where('numParcelleOuTitre', isEqualTo: numParcelle)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } catch (e) {
      print("Erreur lors de la récupération de la parcelle : $e");
      throw Exception("Erreur lors de la récupération de la parcelle : $e");
    }
  }


}
