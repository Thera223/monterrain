import 'package:cloud_firestore/cloud_firestore.dart';

class Demande {
  final String id;
  final String idDemandeur;
  final String statut;
  final String localite;
  final  numParcelle;
  final String? nomProprietaire;
  final String? adresseProprietaire;
  final String? superficieTerrain;
  final String? lieuParcelle;
  final String? numFolios;
  final DateTime? dateSoumission;
  final List<String>? typesDemande;
  late final String? reponse;
  final String? assigneA; // Nouveau champ

  Demande({
    required this.id,
    required this.idDemandeur,
    required this.statut,
    required this.localite,
    this.numParcelle,
    this.nomProprietaire,
    this.adresseProprietaire,
    this.superficieTerrain,
    this.lieuParcelle,
    this.numFolios,
    this.dateSoumission,
    this.typesDemande,
    this.reponse,
    this.assigneA, // Ajout du champ assignéÀ
  });

  // Méthode pour convertir l'objet en Map (compatible avec Firestore)
  Map<String, dynamic> toMap() {
    return {
      'idDemandeur': idDemandeur,
      'statut': statut,
      'localite': localite,
      'numParcelle': numParcelle,
      'nomProprietaire': nomProprietaire,
      'adresseProprietaire': adresseProprietaire,
      'superficieTerrain': superficieTerrain,
      'lieuParcelle': lieuParcelle,
      'numFolios': numFolios,
      'dateSoumission': dateSoumission?.toIso8601String(),
      'typesDemande': typesDemande,
      'reponse': reponse,
      'assigneA': assigneA, // Ajout dans toMap()
    };
  }

  // Méthode pour convertir un Map en objet Demande
  factory Demande.fromMap(String id, Map<String, dynamic> data) {
    return Demande(
      id: id,
      idDemandeur: data['idDemandeur'] ?? '',
      statut: data['statut'] ?? 'En attente',
      localite: data['localite'] ?? '',
      numParcelle: data['numParcelle'],
      nomProprietaire: data['nomProprietaire'],
      adresseProprietaire: data['adresseProprietaire'],
      superficieTerrain: data['superficieTerrain'],
      lieuParcelle: data['lieuParcelle'],
      numFolios: data['numFolios'],
      dateSoumission: data['dateSoumission'] != null
          ? (data['dateSoumission'] as Timestamp).toDate()
          : null,
      typesDemande: data['typesDemande'] != null
          ? List<String>.from(data['typesDemande'])
          : null,
      reponse: data['reponse'],
      assigneA: data['assigneA'], // Ajout du champ assignéÀ
    );
  }
}
