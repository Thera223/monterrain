import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/services/parcelle_service.dart';

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

}
