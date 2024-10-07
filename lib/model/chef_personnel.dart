class ChefPersonnel {
  final String id;
  final String nom;
  final String email;
  final String telephone;
  final String poste; // Chef de Personnel
  final String localite; // Localité couverte par ce Chef
  final List<String>
      personnelIds; // Liste des membres du personnel sous sa gestion

  ChefPersonnel({
    required this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.poste,
    required this.localite, // Ajout de la localité
    required this.personnelIds,
  });

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'poste': poste,
      'localite': localite, // Localité ajoutée ici
      'personnelIds': personnelIds,
    };
  }

  // Convertir une Map Firestore en instance de ChefPersonnel
  factory ChefPersonnel.fromMap(String id, Map<String, dynamic> data) {
    return ChefPersonnel(
      id: id,
      nom: data['nom'],
      email: data['email'],
      telephone: data['telephone'],
      poste: data['poste'],
      localite: data['localite'], // Localité récupérée ici
      personnelIds: List<String>.from(data['personnelIds']),
    );
  }
}
