import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SoumissionDemandePage extends StatefulWidget {
  @override
  _SoumissionDemandePageState createState() => _SoumissionDemandePageState();
}

class _SoumissionDemandePageState extends State<SoumissionDemandePage> {
  int _currentStep = 0;

  // Contrôleurs pour les champs de texte
  final TextEditingController _nomProprietaireController =
      TextEditingController();
  final TextEditingController _lieuNaissanceController =
      TextEditingController();
  final TextEditingController _adresseProprietaireController =
      TextEditingController();
  final TextEditingController _cinNinaController = TextEditingController();
  final TextEditingController _numParcelleController = TextEditingController();
  final TextEditingController _numFoliosController = TextEditingController();
  final TextEditingController _superficieController = TextEditingController();
  final TextEditingController _lieuParcelleController = TextEditingController();

  // Champ Localité
  String? _selectedLocalite;

  // Sélection du mode de paiement
  String? _selectedPaymentMethod;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  // Liste des types de demande avec sélection multiple
  final List<Map<String, dynamic>> typesDeDemande = [
    {
      'type': 'Vérification titre de propriété',
      'cost': 50.0,
      'selected': false
    },
    {'type': 'Litige foncier', 'cost': 100.0, 'selected': false},
    {
      'type': 'Historique de transaction foncière',
      'cost': 75.0,
      'selected': false
    },
  ];

  // Fonction pour calculer le montant total à payer
  double _calculateTotalCost() {
    return typesDeDemande
        .where((type) => type['selected'] == true)
        .fold(0.0, (sum, item) => sum + item['cost']);
  }

Future<void> _submitDemande() async {
    if (_nomProprietaireController.text.isEmpty ||
        _lieuNaissanceController.text.isEmpty ||
        _adresseProprietaireController.text.isEmpty ||
        _cinNinaController.text.isEmpty ||
        _numParcelleController.text.isEmpty ||
        _numFoliosController.text.isEmpty ||
        _superficieController.text.isEmpty ||
        _lieuParcelleController.text.isEmpty ||
        _selectedPaymentMethod == null ||
        _selectedLocalite == null ||
        typesDeDemande.where((type) => type['selected'] == true).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez remplir tous les champs obligatoires.')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Vous devez être connecté pour soumettre une demande.')),
        );
        return;
      }

      List<String> selectedTypes = typesDeDemande
          .where((type) => type['selected'] == true)
          .map((type) => type['type'].toString())
          .toList();

      Map<String, dynamic> demandeData = {
        'idDemandeur': user.uid,
        'nomProprietaire': _nomProprietaireController.text,
        'lieuNaissanceProprietaire': _lieuNaissanceController.text,
        'adresseProprietaire': _adresseProprietaireController.text,
        'cinNina': _cinNinaController.text,
        'numParcelle': _numParcelleController.text,
        'numFolios': _numFoliosController.text,
        'superficieTerrain': _superficieController.text,
        'lieuParcelle': _lieuParcelleController.text,
        'typesDemande': selectedTypes,
        'montantTotal': _calculateTotalCost(),
        'modePaiement': _selectedPaymentMethod,
        'localite': _selectedLocalite,
        'dateSoumission': FieldValue.serverTimestamp(),
        'statut': 'En attente',
      };

      await FirebaseFirestore.instance.collection('demandes').add(demandeData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande soumise avec succès !')),
      );
      // Réinitialiser les champs après la soumission
      _resetForm();
    } catch (e) {
      print('Erreur lors de la soumission de la demande : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la soumission. Réessayez.')),
      );
    }
  }

  void _resetForm() {
    _nomProprietaireController.clear();
    _lieuNaissanceController.clear();
    _adresseProprietaireController.clear();
    _cinNinaController.clear();
    _numParcelleController.clear();
    _numFoliosController.clear();
    _superficieController.clear();
    _lieuParcelleController.clear();
    _selectedLocalite = null;
    _selectedPaymentMethod = null;
    typesDeDemande.forEach((type) {
      type['selected'] = false;
    });
    setState(() {
      _currentStep = 0;
    });
  }





// Étape 1 : Informations sur le propriétaire et la parcelle
 // Étape 1 : Informations sur le propriétaire et la parcelle
 Widget _buildStep1() {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Ajuster les tailles et marges selon la taille de l'écran
    double fieldFontSize =
        screenWidth > 600 ? 18 : 14; // Grand écran, taille de texte
    double fieldPadding =
        screenWidth > 600 ? 10 : 5; // Espacement en fonction de l'écran

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person,
                size: 24, color: Colors.purple), // Icône du formulaire
            SizedBox(width: 8), // Espacement
            Expanded(
              // Utilisation de Expanded pour ajuster le texte
              child: Text(
                'Informations sur le propriétaire et la parcelle :',
                style: TextStyle(
                  fontSize: screenWidth > 600
                      ? 18
                      : 16, // Adaptation de la taille du texte
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                overflow:
                    TextOverflow.ellipsis, // Empêcher le débordement de texte
                maxLines: 2, // Limiter à deux lignes si nécessaire
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Champs pour les informations du propriétaire et de la parcelle
        _buildTextFormField(
          _nomProprietaireController,
          'Nom complet du propriétaire',
          icon: Icons.account_circle, // Icône pour le nom
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 10),

        _buildTextFormField(
          _lieuNaissanceController,
          'Lieu et date de naissance',
          icon: Icons.cake, // Icône pour la naissance
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 10),

        _buildTextFormField(
          _adresseProprietaireController,
          'Adresse du propriétaire',
          icon: Icons.home, // Icône pour l'adresse
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 10),

        _buildTextFormField(
          _cinNinaController,
          'Numéro CIN ou NINA',
          icon: Icons.credit_card, // Icône pour CIN ou NINA
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 10),

        _buildTextFormField(
          _numParcelleController,
          'Numéro de la parcelle',
          icon: Icons.location_on, // Icône pour numéro de la parcelle
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 10),

        _buildTextFormField(
          _numFoliosController,
          'Numéro d’enregistrement folios',
          icon: Icons.folder, // Icône pour le numéro folios
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 10),

        _buildTextFormField(
          _superficieController,
          'Superficie du terrain',
          icon: Icons.landscape, // Icône pour la superficie
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 10),

        _buildTextFormField(
          _lieuParcelleController,
          'Lieu de la parcelle',
          icon: Icons.map, // Icône pour lieu de la parcelle
          fontSize: fieldFontSize,
          padding: fieldPadding,
        ),
        SizedBox(height: 16),

        // Champ Localité
        Row(
          children: [
            Icon(Icons.location_city,
                size: 24, color: Colors.purple), // Icône pour localité
            SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedLocalite,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocalite = newValue;
                  });
                },
                items: ['Bamako', 'Kati', 'Kayes', 'Koulikoro', 'Segou']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Localité',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }





// Fonction utilitaire pour construire des champs de texte avec icônes
  

// Étape 2 : Sélection du type de demande (avec sélection multiple)
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assignment,
                size: 24, color: Colors.purple), // Icône à côté du titre
            SizedBox(width: 8), // Espacement
            Text(
              'Sélectionnez les types de demande :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Boucle à travers les types de demande
        for (var typeDemande in typesDeDemande)
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0), // Espacement entre les options
            child: CheckboxListTile(
              activeColor: Colors.purple, // Couleur pour la case cochée
              title: Row(
                children: [
                  // Icône différente selon le type de demande
                  Icon(
                    typeDemande['type'] == 'Vérification titre de propriété'
                        ? Icons.verified_user // Icône de vérification
                        : typeDemande['type'] == 'Litige foncier'
                            ? Icons.gavel // Icône pour le litige
                            : Icons.history, // Icône pour l'historique
                    color: Colors.blueAccent, // Couleur des icônes
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${typeDemande['type']} (${typeDemande['cost']}€)', // Texte de l'option
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Limite si le texte est trop long
                    ),
                  ),
                ],
              ),
              value: typeDemande['selected'],
              onChanged: (bool? value) {
                setState(() {
                  typeDemande['selected'] = value!;
                });
              },
            ),
          ),
      ],
    );
  }


// Étape 3 : Paiement
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Affichage du montant total avec un style plus accentué
        Row(
          children: [
            Icon(Icons.attach_money,
                size: 24, color: Colors.green), // Icône pour le montant
            SizedBox(width: 8), // Espacement
            Text(
              'Montant total à payer : ${_calculateTotalCost()}€',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Sélection du mode de paiement
        Text(
          'Sélectionnez le mode de paiement :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        SizedBox(height: 16),

        // Option Carte Bancaire avec une icône et une image
        RadioListTile<String>(
          title: Row(
            children: [
              Icon(Icons.credit_card,
                  color: Colors.blue, size: 30), // Icône de carte bancaire
              SizedBox(width: 10), // Espacement
              Text(
                'Carte bancaire',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          value: 'Carte bancaire',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value;
            });
          },
          activeColor: Colors.purple, // Couleur d'accent pour la sélection
        ),
        SizedBox(height: 10),

        // Option Mobile Money avec une icône et une image
        RadioListTile<String>(
          title: Row(
            children: [
              Icon(Icons.smartphone,
                  color: Colors.orange, size: 30), // Icône de mobile
              SizedBox(width: 10), // Espacement
              Text(
                'Mobile Money',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          value: 'Mobile Money',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value;
            });
          },
          activeColor: Colors.purple, // Couleur d'accent pour la sélection
        ),
      ],
    );
  }


  // Étape 4 : Confirmation et envoi des données
  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 100, color: Colors.green),
        SizedBox(height: 16),
        Text(
          'Votre demande a été soumise avec succès !',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Text('Retour à l\'accueil'),
        ),
      ],
    );
  }

  // Rendu de l'interface en fonction de l'étape actuelle
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        _submitDemande(); // Envoi des données à Firebase lors de la confirmation
        return _buildStep4();
      default:
        return _buildStep1();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Soumission de demande'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProgressBar(),
              SizedBox(height: 20),
              _buildCurrentStep(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      child: Text('Retour'),
                    ),
                  if (_currentStep < 3)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentStep++;
                        });
                      },
                      child: Text('Suivant'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Barre de progression horizontale
  Widget _buildProgressBar() {
    double progress = (_currentStep + 1) / 4; // 4 étapes au total
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey[300],
        color: Colors.purple,
        minHeight: 8.0,
      ),
    );
  }

  // Fonction utilitaire pour construire des champs de texte avec padding
// Fonction utilitaire pour construire des champs de texte avec icônes
  Widget _buildTextFormField(TextEditingController controller, String label,
      {IconData? icon, required double fontSize, required double padding}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: Colors.purple), // Ajout d'icône personnalisée
          labelText: label,
          labelStyle: TextStyle(fontSize: fontSize),
          filled: true,
          fillColor: Colors.purple[50], // Couleur de fond légère
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Coins arrondis
          ),
        ),
      ),
    );
  }

}
