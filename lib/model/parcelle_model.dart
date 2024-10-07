class Parcelle {
  final String id;
  final String nomProprietaire;
  final String prenomProprietaire;
  final String addresseProprietaire;
  final int numParcelleOuTitre;
  final int numEnregFolios;
  final String superficieTerrain;
  final String lieuParcelle;
  final String planParcelle;
  final String coutMoyenParcelle;
  final double latitude;
  final double longitude;
  final bool verification; // Pour indiquer si la vérification correspond
  final bool litige; // S'il y a des litiges fonciers
  final List<String>
      historiqueTransactions; // Historique des transactions sur la parcelle

  Parcelle({
    required this.id,
    required this.nomProprietaire,
    required this.prenomProprietaire,
    required this.addresseProprietaire,
    required this.numParcelleOuTitre,
    required this.numEnregFolios,
    required this.superficieTerrain,
    required this.lieuParcelle,
    required this.planParcelle,
    required this.coutMoyenParcelle,
    required this.latitude,
    required this.longitude,
    required this.verification, // Champ pour vérifier la validité
    required this.litige, // Champ pour indiquer les litiges
    required this.historiqueTransactions, // Liste des transactions foncières
  });

  // Convertir une parcelle en Map (pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nomProprietaire': nomProprietaire,
      'prenomProprietaire': prenomProprietaire,
      'addresseProprietaire': addresseProprietaire,
      'numParcelleOuTitre': numParcelleOuTitre,
      'numEnregFolios': numEnregFolios,
      'superficieTerrain': superficieTerrain,
      'lieuParcelle': lieuParcelle,
      'planParcelle': planParcelle,
      'coutMoyenParcelle': coutMoyenParcelle,
      'latitude': latitude,
      'longitude': longitude,
      'verification': verification,
      'litige': litige,
      'historiqueTransactions': historiqueTransactions,
    };
  }

  factory Parcelle.fromMap(String id, Map<String, dynamic> data) {
    return Parcelle(
      id: id,
      nomProprietaire: data['nomProprietaire'] ?? '',
      prenomProprietaire: data['prenomProprietaire'] ?? '',
      addresseProprietaire: data['addresseProprietaire'] ?? '',
      numParcelleOuTitre: data['numParcelleOuTitre'] ?? 0,
      numEnregFolios: data['numEnregFolios'] ?? 0,
      superficieTerrain: data['superficieTerrain'] ?? '',
      lieuParcelle: data['lieuParcelle'] ?? '',
      planParcelle: data['planParcelle'] ?? '',
      coutMoyenParcelle: data['coutMoyenParcelle'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      verification: data['verification'] ?? false,
      litige: data['litige'] ?? false,
      historiqueTransactions:
          List<String>.from(data['historiqueTransactions'] ?? []),
    );
  }
}
