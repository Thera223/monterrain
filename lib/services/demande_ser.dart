import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/services/parcelle_service.dart';
import 'package:intl/intl.dart';


class DemandeService extends ChangeNotifier {
  final CollectionReference demandeCollection =
      FirebaseFirestore.instance.collection('demandes');
      

  // Ajouter une nouvelle demande avec localité
  Future<void> addDemande(Demande demande) async {
    try {
      await demandeCollection.add(demande.toMap());
      print("Demande ajoutée avec succès.");
    } catch (e) {
      print("Erreur lors de l'ajout de la demande : $e");
    }
  }

  // Récupérer toutes les demandes
  Future<List<Demande>> getAllDemandes() async {
    try {
      QuerySnapshot querySnapshot = await demandeCollection.get();
      return querySnapshot.docs
          .map((doc) =>
              Demande.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des demandes : $e");
      return [];
    }
  }

  // Récupérer les demandes par localité
  Future<List<Demande>> getDemandesByLocalite(localite) async {
    try {
      QuerySnapshot querySnapshot =
          await demandeCollection.where('localite', isEqualTo: localite).get();
      return querySnapshot.docs
          .map((doc) =>
              Demande.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des demandes pour $localite : $e");
      return [];
    }
  }
  Future<String?> getLocaliteForChef(String chefId) async {
    try {
      final chefDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(chefId)
          .get();

      if (chefDoc.exists && chefDoc.data()?['role'] == 'chef_personnel') {
        return chefDoc
            .data()?['localite']; // Retourne la localité associée au chef
      } else {
        print("Chef non trouvé ou rôle incorrect.");
      }
    } catch (e) {
      print('Erreur lors de la récupération de la localité du chef: $e');
    }
    return null;
  }

  // Assigner une demande à un personnel
Future<void> assignDemande(String demandeId, String personnelId) async {
    try {
      await demandeCollection.doc(demandeId).update({
        'assigneA': personnelId,
        'statut': 'En cours',
      });
      notifyListeners(); // Notifie les widgets écoutant ce service
    } catch (e) {
      throw Exception("Erreur lors de l'assignation de la demande : $e");
    }
  }


  // Mettre à jour le statut d'une demande
  Future<void> updateStatutDemande(
      String demandeId, String nouveauStatut) async {
    try {
      await demandeCollection.doc(demandeId).update({
        'statut': nouveauStatut,
      });
      notifyListeners();
      print("Statut de la demande mis à jour.");
    } catch (e) {
      throw Exception(
          "Erreur lors de la mise à jour du statut de la demande : $e");
    }
  }

  // Filtrer les demandes par statut (ex : 'En attente', 'En cours', 'Terminée')
  Future<List<Demande>> getDemandesByStatut(String statut) async {
    try {
      QuerySnapshot querySnapshot =
          await demandeCollection.where('statut', isEqualTo: statut).get();
      return querySnapshot.docs
          .map((doc) =>
              Demande.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
          
    } catch (e) {
      print(
          "Erreur lors de la récupération des demandes avec statut $statut : $e");
      return [];
    }
  }

  Future<void> soumettreDemande({
    required String idDemandeur,
    required String idParcelle,
    required String nomCompletProprietaire,
    required String lieuDateNaisProprietaire,
    required String adresseProprietaire,
    required String numCINouNINA,
    required String typeDemande,
    required double montant,
    required DateTime dateSoumission,
  }) async {
    try {
      await demandeCollection.add({
        'id_demandeur': idDemandeur,
        'id_parcelle': idParcelle,
        'nom_complet_proprietaire': nomCompletProprietaire,
        'lieu_date_nais_proprietaire': lieuDateNaisProprietaire,
        'adresse_proprietaire': adresseProprietaire,
        'num_CIN_ou_NINA': numCINouNINA,
        'type_demande': typeDemande,
        'cout_moyen_parcelle_m2': montant,
        'date_soumission': dateSoumission,
        'status': 'En attente',
      });
    } catch (e) {
      print("Erreur lors de la soumission de la demande: $e");
    }
  }

  // Récupérer les demandes de l'utilisateur connecté
  Future<List<Demande>> getDemandesByUser(String idDemandeur) async {
    try {
      QuerySnapshot querySnapshot = await demandeCollection
          .where('idDemandeur', isEqualTo: idDemandeur)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('Aucune demande trouvée pour l\'utilisateur $idDemandeur');
        return [];
      }

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Demande.fromMap(doc.id, data);
      }).toList();
      
    } catch (e) {
      print("Erreur lors de la récupération des demandes du demandeur : $e");
      return [];
    }
  }
  // Récupérer les demandes assignées à un personnel
  // Méthode pour récupérer les demandes assignées à un personnel
Future<List<Demande>> getDemandesAssignees(String personnelId) async {
    try {
      print('Recherche des demandes assignées à : $personnelId');
      QuerySnapshot querySnapshot = await demandeCollection
          .where('assigneA',
              isEqualTo:
                  personnelId) // Assure-toi que le champ "assigneA" est bien l'ID
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('Aucune demande assignée trouvée pour ce personnel.');
        return [];
      }

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        print(
            'Demande trouvée : ${data['numParcelle']}, assignée à : ${data['assigneA']}');
        return Demande.fromMap(doc.id, data);
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des demandes assignées : $e');
      return [];
    }
  }


Future<List<Demande>> getDemandesByParcelle(String numParcelle) async {
    try {
      QuerySnapshot querySnapshot = await demandeCollection
          .where('numParcelle', isEqualTo: numParcelle)
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

  // Méthode pour répondre à une demande
  Future<void> repondreDemande(String demandeId, String reponse) async {
    try {
      await demandeCollection.doc(demandeId).update({
        'reponse': reponse,  // Mettre à jour la réponse de la demande
        'statut': 'Répondue',  // Changer le statut une fois la réponse donnée
      });
      print("Réponse enregistrée avec succès.");
    } catch (e) {
      print("Erreur lors de la réponse à la demande : $e");
      throw Exception("Erreur lors de la réponse à la demande : $e");
    }
  }
void verifierParcelle(BuildContext context, Demande demande) async {
    final parcelleService =
        Provider.of<ParcelleService>(context, listen: false);

    try {
      final parcelle =
          await parcelleService.getParcelleByNumero(demande.numParcelle ?? '');

      if (parcelle != null) {
        // Afficher les détails de la parcelle
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Parcelle trouvée'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Nom Propriétaire: ${parcelle['nomProprietaire'] ?? 'Non renseigné'}'),
                Text(
                    'Adresse: ${parcelle['addresseProprietaire'] ?? 'Non renseignée'}'),
                Text('Lieu: ${parcelle['lieuParcelle'] ?? 'Non renseigné'}'),
                // Ajouter d'autres informations pertinentes
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Parcelle non trouvée
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parcelle non trouvée')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la vérification : $e')),
      );
    }
  }

void traiterDemande(BuildContext context, Demande demande) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Traitement de la demande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Type de demande: ${demande.typesDemande?.join(', ')}'),
            // Continuer avec des actions spécifiques en fonction du type de demande
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Continuer le traitement ici
              Navigator.of(ctx).pop();
            },
            child: Text('Continuer'),
          ),
        ],
      ),
    );
  }
  // Méthode pour obtenir le nombre total de demandes
  Future<int> getTotalRequests() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('demandes').get();
      return querySnapshot.size;
    } catch (e) {
      print("Erreur lors de la récupération du nombre de demandes : $e");
      return 0;
    }
  }

  // Méthode pour obtenir le nombre total de réponses (statut 'Répondu')
  Future<int> getTotalResponses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('demandes')
          .where('statut', isEqualTo: 'Répondu')
          .get();
      return querySnapshot.size;
    } catch (e) {
      print("Erreur lors de la récupération des réponses : $e");
      return 0;
    }
  }


  // Méthode pour obtenir le nombre de demandes par localité et statut
Future<int> getDemandesCount({
    required String localite,
    required String statut,
  }) async {
    try {
      print(
          'Récupération des demandes pour Localité: $localite et Statut: $statut');

      final querySnapshot = await demandeCollection
          .where('localite', isEqualTo: localite)
          .where('statut', isEqualTo: statut)
          .get();

      print('Nombre de demandes trouvées : ${querySnapshot.docs.length}');

      for (var doc in querySnapshot.docs) {
      }

      return querySnapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération du nombre de demandes : $e');
      return 0;
    }
  }







  // Récupérer le nombre total de demandes en cours
  Future<int> getTotalDemandesEnCours() async {
    try {
      QuerySnapshot snapshot = await demandeCollection
          .where('statut', isEqualTo: 'En cours')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des demandes en cours: $e');
      return 0;
    }
  }

  // Récupérer le nombre total de demandes en attente
  Future<int> getTotalDemandesEnAttente() async {
    try {
      QuerySnapshot snapshot = await demandeCollection
          .where('statut', isEqualTo: 'En attente')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des demandes en attente: $e');
      return 0;
    }
  }

  // Récupérer le nombre total de demandes refusées
  Future<int> getTotalDemandesRefusees() async {
    try {
      QuerySnapshot snapshot = await demandeCollection
          .where('statut', isEqualTo: 'Refusée')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des demandes refusées: $e');
      return 0;
    }
  }

  // Récupérer le nombre total de parcelles vérifiées
  Future<int> getTotalParcellesVerifiees() async {
    try {
      QuerySnapshot snapshot = await demandeCollection
          .where('typeDemande', arrayContains: 'Vérification')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des parcelles vérifiées: $e');
      return 0;
    }
  }

  // Récupérer le nombre total de parcelles avec litige
  Future<int> getTotalParcellesAvecLitige() async {
    try {
      QuerySnapshot snapshot = await demandeCollection
          .where('typeDemande', arrayContains: 'Litige foncier')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des parcelles avec litige: $e');
      return 0;
    }
  }

  // Récupérer le nombre total de demandeurs actifs
  Future<int> getTotalDemandeursActifs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'demandeur')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Erreur lors de la récupération des demandeurs actifs: $e');
      return 0;
    }
  }


    // Méthode pour récupérer les demandes filtrées par date
  Future<List<Demande>> getDemandesByDate(DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await demandeCollection
          .where('dateSoumission', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('dateSoumission', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Demande.fromMap(doc.id, data);
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des demandes par date : $e");
      return [];
    }
  }



// // Méthode pour récupérer les demandes agrégées par date
// Future<Map<String, int>> getDemandesGroupedByDate() async {
//   Map<String, int> demandesByDate = {};

//   try {
//     QuerySnapshot querySnapshot = await demandeCollection.get();
//     for (var doc in querySnapshot.docs) {
//       DateTime date = (doc['dateSoumission'] as Timestamp).toDate();
//       String dateStr = '${date.year}-${date.month}-${date.day}';
//       if (demandesByDate.containsKey(dateStr)) {
//         demandesByDate[dateStr] = demandesByDate[dateStr]! + 1;
//       } else {
//         demandesByDate[dateStr] = 1;
//       }
//     }
//   } catch (e) {
//     print('Erreur lors de l\'agrégation des demandes par date : $e');
//   }

//   return demandesByDate;
// }

// // Méthode pour récupérer les réponses (statut 'Répondu') agrégées par date
// Future<Map<String, int>> getResponsesGroupedByDate() async {
//   Map<String, int> responsesByDate = {};

//   try {
//     QuerySnapshot querySnapshot =
//         await demandeCollection.where('statut', isEqualTo: 'Répondu').get();
//     for (var doc in querySnapshot.docs) {
//       DateTime date = (doc['dateSoumission'] as Timestamp).toDate();
//       String dateStr = '${date.year}-${date.month}-${date.day}';
//       if (responsesByDate.containsKey(dateStr)) {
//         responsesByDate[dateStr] = responsesByDate[dateStr]! + 1;
//       } else {
//         responsesByDate[dateStr] = 1;
//       }
//     }
//   } catch (e) {
//     print('Erreur lors de l\'agrégation des réponses par date : $e');
//   }

//   return responsesByDate;
// }


// Méthode pour récupérer les demandes agrégées par date
  Future<Map<String, int>> getDemandesGroupedByDate() async {
    Map<String, int> demandesByDate = {};

    try {
      QuerySnapshot querySnapshot = await demandeCollection.get();
      for (var doc in querySnapshot.docs) {
        DateTime date = (doc['dateSoumission'] as Timestamp).toDate();
        String dateStr = DateFormat('yyyy-MM-dd').format(date);
        demandesByDate.update(dateStr, (value) => value + 1, ifAbsent: () => 1);
      }
    } catch (e) {
      print('Erreur lors de l\'agrégation des demandes par date : $e');
    }

    return demandesByDate;
  }

// Méthode pour récupérer les réponses (statut 'Répondu') agrégées par date
  Future<Map<String, int>> getResponsesGroupedByDate() async {
    Map<String, int> responsesByDate = {};

    try {
      QuerySnapshot querySnapshot =
          await demandeCollection.where('statut', isEqualTo: 'Répondu').get();
      for (var doc in querySnapshot.docs) {
        DateTime date = (doc['dateSoumission'] as Timestamp).toDate();
        String dateStr = DateFormat('yyyy-MM-dd').format(date);
        responsesByDate.update(dateStr, (value) => value + 1,
            ifAbsent: () => 1);
      }
    } catch (e) {
      print('Erreur lors de l\'agrégation des réponses par date : $e');
    }

    return responsesByDate;
  }



}


  
