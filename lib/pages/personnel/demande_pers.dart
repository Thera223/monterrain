// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:terrain/services/demande_ser.dart';
// import 'package:terrain/model/demande.dart';
// import 'package:terrain/services/parcelle_service.dart';
// import 'package:terrain/services/user_service.dart';

// class PersonnelDemandesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser; // Utilisateur connecté
//     final demandeService = Provider.of<DemandeService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Demandes assignées'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Demande>>(
//         future: demandeService.getDemandesAssignees(
//             user!.uid), // Récupérer les demandes assignées
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Aucune demande assignée.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final demande = snapshot.data![index];

//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey.withOpacity(0.3)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         blurRadius: 4,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     leading: Icon(Icons.insert_drive_file_rounded),
//                     title: Text(
//                         'Nº Parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8),
//                         Text(
//                             'Nom Propriétaire: ${demande.nomProprietaire ?? 'Inconnu'}'),
//                         SizedBox(height: 4),
//                         Text('Statut: ${demande.statut}'),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.info_outline),
//                       onPressed: () {
//                         showDetails(context, demande);
//                       },
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Méthode pour afficher les détails d'une demande
//   void showDetails(BuildContext context, Demande demande) {
//     final userService = Provider.of<UserService>(context, listen: false);

//     showDialog(
//       context: context,
//       builder: (ctx) => FutureBuilder<Map<String, dynamic>?>(
//         future: userService.getUserById(
//             demande.idDemandeur), // Récupérer les infos du demandeur
//         builder: (context, demandeurSnapshot) {
//           if (!demandeurSnapshot.hasData) {
//             return AlertDialog(
//               title: Text('Chargement...'),
//               content: Center(child: CircularProgressIndicator()),
//             );
//           }

//           final demandeur = demandeurSnapshot.data!;

//           return AlertDialog(
//             title: Text('Détails de la demande'),
//             content: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('--- Informations sur la demande ---',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text('ID Demande: ${demande.id}'),
//                   Text(
//                       'Numéro de parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
//                   Text(
//                       'Nom du propriétaire: ${demande.nomProprietaire ?? 'Non renseigné'}'),
//                   Text(
//                       'Adresse du propriétaire: ${demande.adresseProprietaire ?? 'Non renseignée'}'),
//                   Text(
//                       'Superficie du terrain: ${demande.superficieTerrain ?? 'Non renseignée'}'),
//                   Text(
//                       'Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
//                   Text('Numéro de folios: ${demande.numFolios ?? 'Inconnu'}'),
//                   Text('Statut: ${demande.statut}'),
//                   Text(
//                       'Date de soumission: ${demande.dateSoumission?.toLocal().toIso8601String() ?? 'Non renseignée'}'),
//                   Text('Assignée à: ${demande.assigneA ?? 'Non assignée'}'),
//                   SizedBox(height: 10),
//                   Text(
//                       'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
//                   SizedBox(height: 10),
//                   Divider(),
//                   Text('--- Informations sur le demandeur ---',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text(
//                       'Nom du demandeur: ${demandeur['nom'] ?? 'Nom non renseigné'}'),
//                   Text(
//                       'Adresse du demandeur: ${demandeur['adresse'] ?? 'Adresse non renseignée'}'),
//                   Text('Email: ${demandeur['email'] ?? 'Email non renseigné'}'),
//                   Text(
//                       'Téléphone: ${demandeur['telephone'] ?? 'Téléphone non renseigné'}'),
//                   Text(
//                       'Numéro CIN ou NINA: ${demandeur['numCINouNINA'] ?? 'Non renseigné'}'),
//                   SizedBox(height: 10),

//                   // Boutons pour les actions sur la parcelle
//                   ElevatedButton(
//                     onPressed: () {
//                       verifierEtEnvoyerReponse(context,
//                           demande); // Vérification et envoi des résultats
//                     },
//                     child: Text('Vérifier et envoyer réponse'),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text('Fermer'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Méthode pour vérifier les informations soumises et générer une réponse automatique
//   void verifierEtEnvoyerReponse(BuildContext context, Demande demande) async {
//     final parcelleService =
//         Provider.of<ParcelleService>(context, listen: false);
//     final demandeService = Provider.of<DemandeService>(context, listen: false);

//     try {
//       // Vérification du numéro de parcelle
//       if (demande.numParcelle == null) {
//         throw 'Numéro de parcelle manquant.';
//       }

//       final int numParcelle =
//           int.tryParse(demande.numParcelle.toString()) ?? -1;
//       if (numParcelle == -1) {
//         throw 'Numéro de parcelle invalide.';
//       }

//       // Récupération des informations de la parcelle
//       final parcelleData =
//           await parcelleService.getParcelleByNumero(numParcelle);

//       if (parcelleData != null) {
//         // Résultat de la vérification des informations soumises
//         List<String> differences = [];
//         if (demande.nomProprietaire != parcelleData['nomProprietaire']) {
//           differences.add('Nom incorrect');
//         }
//         if (demande.adresseProprietaire !=
//             parcelleData['addresseProprietaire']) {
//           differences.add('Adresse incorrecte');
//         }
//         if (demande.superficieTerrain != parcelleData['superficieTerrain']) {
//           differences.add('Superficie incorrecte');
//         }
//         if (demande.lieuParcelle != parcelleData['lieuParcelle']) {
//           differences.add('Lieu incorrect');
//         }

//         // Résultat de la vérification du litige
//         bool litigePresent = parcelleData['litige'] ?? false;

//         // Résultat de la vérification de l'historique des transactions
//         List<String> historiqueTransactions =
//             parcelleData['historiqueTransactions']?.cast<String>() ?? [];

//         // Construction de la réponse automatique
//         String reponse = '';

//         // Résultat de la vérification des informations
//         if (differences.isEmpty) {
//           reponse += '- Vérification des informations : Tout est correct.\n';
//         } else {
//           reponse +=
//               '- Vérification des informations : Incohérences trouvées (${differences.join(', ')}).\n';
//         }

//         // Résultat de la vérification du litige
//         reponse += '- Vérification des litiges : ';
//         reponse += litigePresent ? 'Litige trouvé.' : 'Aucun litige.\n';

//         // Résultat de l'historique des transactions
//         reponse += '- Historique des transactions : ';
//         if (historiqueTransactions.isEmpty) {
//           reponse += 'Pas d\'historique trouvé.\n';
//         } else {
//           reponse += 'Historique : ${historiqueTransactions.join(', ')}\n';
//         }

//         // Envoi de la réponse automatique
//         await demandeService.repondreDemande(demande.id, reponse);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Réponse envoyée avec succès')),
//         );
//       } else {
//         throw 'Parcelle non trouvée.';
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur lors de la vérification : $e')),
//       );
//     }
//   }
// }

//BOB
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:terrain/services/demande_ser.dart';
// import 'package:terrain/model/demande.dart';
// import 'package:terrain/services/parcelle_service.dart';
// import 'package:terrain/services/user_service.dart';

// class PersonnelDemandesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser; // Utilisateur connecté
//     final demandeService = Provider.of<DemandeService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Demandes assignées'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Demande>>(
//         future: demandeService.getDemandesAssignees(
//             user!.uid), // Récupérer les demandes assignées
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Aucune demande assignée.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final demande = snapshot.data![index];

//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey.withOpacity(0.3)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         blurRadius: 4,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     leading: Icon(Icons.insert_drive_file_rounded),
//                     title: Text(
//                         'Nº Parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8),
//                         Text(
//                             'Nom Propriétaire: ${demande.nomProprietaire ?? 'Inconnu'}'),
//                         SizedBox(height: 4),
//                         Text('Statut: ${demande.statut}'),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.info_outline),
//                       onPressed: () {
//                         showDetails(context, demande);
//                       },
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Méthode pour afficher les détails d'une demande
//   void showDetails(BuildContext context, Demande demande) {
//     final userService = Provider.of<UserService>(context, listen: false);

//     showDialog(
//       context: context,
//       builder: (ctx) => FutureBuilder<Map<String, dynamic>?>(
//         future: userService.getUserById(
//             demande.idDemandeur), // Récupérer les infos du demandeur
//         builder: (context, demandeurSnapshot) {
//           if (!demandeurSnapshot.hasData) {
//             return AlertDialog(
//               title: Text('Chargement...'),
//               content: Center(child: CircularProgressIndicator()),
//             );
//           }

//           final demandeur = demandeurSnapshot.data!;

//           return AlertDialog(
//             title: Text('Détails de la demande'),
//             content: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('--- Informations sur la demande ---',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text('ID Demande: ${demande.id}'),
//                   Text(
//                       'Numéro de parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
//                   Text(
//                       'Nom du propriétaire: ${demande.nomProprietaire ?? 'Non renseigné'}'),
//                   Text(
//                       'Adresse du propriétaire: ${demande.adresseProprietaire ?? 'Non renseignée'}'),
//                   Text(
//                       'Superficie du terrain: ${demande.superficieTerrain ?? 'Non renseignée'}'),
//                   Text(
//                       'Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
//                   Text('Numéro de folios: ${demande.numFolios ?? 'Inconnu'}'),
//                   Text('Statut: ${demande.statut}'),
//                   Text(
//                       'Date de soumission: ${demande.dateSoumission?.toLocal().toIso8601String() ?? 'Non renseignée'}'),
//                   Text('Assignée à: ${demande.assigneA ?? 'Non assignée'}'),
//                   SizedBox(height: 10),
//                   Text(
//                       'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
//                   SizedBox(height: 10),
//                   Divider(),
//                   Text('--- Informations sur le demandeur ---',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text(
//                       'Nom du demandeur: ${demandeur['nom'] ?? 'Nom non renseigné'}'),
//                   Text(
//                       'Adresse du demandeur: ${demandeur['adresse'] ?? 'Adresse non renseignée'}'),
//                   Text('Email: ${demandeur['email'] ?? 'Email non renseigné'}'),
//                   Text(
//                       'Téléphone: ${demandeur['telephone'] ?? 'Téléphone non renseigné'}'),
//                   Text(
//                       'Numéro CIN ou NINA: ${demandeur['numCINouNINA'] ?? 'Non renseigné'}'),
//                   SizedBox(height: 10),

//                   // Boutons pour les actions sur la parcelle
//                   ElevatedButton(
//                     onPressed: () {
//                       verifierEtEnvoyerReponse(context,
//                           demande); // Vérification et envoi des résultats
//                     },
//                     child: Text('Vérifier et envoyer réponse'),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text('Fermer'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Méthode pour vérifier les informations soumises et générer une réponse automatique en fonction des types demandés
// void verifierEtEnvoyerReponse(BuildContext context, Demande demande) async {
//     final parcelleService =
//         Provider.of<ParcelleService>(context, listen: false);
//     final demandeService = Provider.of<DemandeService>(context, listen: false);

//     String reponse = ''; // Initialisation de la réponse

//     try {
//       // Vérification du numéro de parcelle
//       if (demande.numParcelle == null || demande.numParcelle == '') {
//         reponse = 'Numéro de parcelle manquant ou invalide.';
//         await demandeService.repondreDemande(demande.id, reponse);
//         await demandeService.updateStatutDemande(demande.id, 'Répondu');
//         return;
//       }

//       final int numParcelle =
//           int.tryParse(demande.numParcelle.toString()) ?? -1;
//       if (numParcelle == -1) {
//         reponse = 'Le numéro de parcelle est incorrect ou invalide.';
//         await demandeService.repondreDemande(demande.id, reponse);
//         await demandeService.updateStatutDemande(demande.id, 'Répondu');
//         return;
//       }

//       // Récupération des informations de la parcelle
//       final parcelleData =
//           await parcelleService.getParcelleByNumero(numParcelle);

//       if (parcelleData != null) {
//         // Si les types de demande sont bien récupérés
//         if (demande.typesDemande != null && demande.typesDemande!.isNotEmpty) {
//           for (String typeDemande in demande.typesDemande!) {
//             // Gestion du type 'Vérification titre de propriété'
//             if (typeDemande == 'Vérification titre de propriété') {
//               List<String> differences = [];
//               if (demande.nomProprietaire != parcelleData['nomProprietaire']) {
//                 differences.add('Nom incorrect');
//               }
//               if (demande.adresseProprietaire !=
//                   parcelleData['addresseProprietaire']) {
//                 differences.add('Adresse incorrecte');
//               }
//               if (demande.superficieTerrain !=
//                   parcelleData['superficieTerrain']) {
//                 differences.add('Superficie incorrecte');
//               }
//               if (demande.lieuParcelle != parcelleData['lieuParcelle']) {
//                 differences.add('Lieu incorrect');
//               }

//               if (differences.isEmpty) {
//                 reponse +=
//                     '- Vérification des informations : Tout est correct.\n';
//               } else {
//                 reponse +=
//                     '- Vérification des informations : Incohérences trouvées (${differences.join(', ')}).\n';
//               }
//             }

//             // Gestion du type 'Historique de transaction foncière'
//             if (typeDemande == 'Historique de transaction foncière') {
//               List<String> historiqueTransactions =
//                   parcelleData['historiqueTransactions']?.cast<String>() ?? [];

//               reponse += '- Historique des transactions : ';
//               if (historiqueTransactions.isEmpty) {
//                 reponse += 'Pas d\'historique trouvé.\n';
//               } else {
//                 reponse +=
//                     'Historique : ${historiqueTransactions.join(', ')}\n';
//               }
//             }

//             // Gestion du type 'Litige foncier'
//             if (typeDemande == 'Litige foncier') {
//               bool litigePresent = parcelleData['litige'] ?? false;
//               reponse += '- Vérification des litiges : ';
//               reponse += litigePresent ? 'Litige trouvé.\n' : 'Aucun litige.\n';
//             }
//           }

//           // Si la réponse n'a pas été générée pour une raison quelconque
//           if (reponse.isEmpty) {
//             reponse = 'Aucun type de demande valide n\'a été trouvé.';
//           }

//           // Envoi de la réponse après vérification
//           await demandeService.repondreDemande(demande.id, reponse);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Réponse envoyée avec succès')),
//           );
//         } else {
//           // Si aucun type de demande n'est trouvé dans la demande
//           reponse = 'Aucun type de demande valide trouvé dans la demande.';
//           await demandeService.repondreDemande(demande.id, reponse);
//           await demandeService.updateStatutDemande(demande.id, 'Répondu');
//         }
//       } else {
//         // Si la parcelle n'est pas trouvée, envoyer une réponse appropriée
//         reponse = 'Le numéro de parcelle fourni est incorrect ou introuvable.';
//         await demandeService.repondreDemande(demande.id, reponse);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Réponse envoyée : parcelle introuvable')),
//         );
//       }

//       // Mettre à jour le statut de la demande à "Répondu"
//       await demandeService.updateStatutDemande(demande.id, 'Répondu');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur lors de la vérification : $e')),
//       );
//     }
//   }

// }

//BOB

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/services/parcelle_service.dart';
import 'package:terrain/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:terrain/widgets/bar_nav_pers.dart';
import 'dart:convert';

import 'package:terrain/widgets/contenudahchef.dart';

class PersonnelDemandesPage extends StatefulWidget {
  @override
  _PersonnelDemandesPageState createState() => _PersonnelDemandesPageState();
}

class _PersonnelDemandesPageState extends State<PersonnelDemandesPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final demandeService = Provider.of<DemandeService>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Demandes assignées'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Demande>>(
        future: demandeService.getDemandesAssignees(
            user!.uid), // Récupérer les demandes assignées
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune demande assignée.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final demande = snapshot.data![index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.insert_drive_file_rounded,
                        color: Colors.purple),
                    title: Text(
                      'Nº Parcelle: ${demande.numParcelle ?? 'Inconnu'}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.purple),
                            SizedBox(width: 4),
                            Text(
                              demande.dateSoumission != null
                                  ? '${demande.dateSoumission!.toLocal()}'
                                  : 'Date inconnue',
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text('Statut: ${demande.statut}'),
                        Text(
                            'Nom Propriétaire: ${demande.nomProprietaire ?? 'Inconnu'}'),
                        Text(
                            'Adresse Propriétaire: ${demande.adresseProprietaire ?? 'Inconnue'}'),
                        Text(
                            'Superficie: ${demande.superficieTerrain ?? 'Inconnue'}'),
                        Text(
                            'Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.purple),
                      onPressed: () {
                        showDetails(context, demande);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
bottomNavigationBar: CustomBottomNavBarp(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }

  // Gestion du changement de l'index de la barre de navigation
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/personnel-mobile');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/personnel-profil');
        break;
    }
  }

  // Méthode pour afficher les détails d'une demande avec une interface améliorée
  void showDetails(BuildContext context, Demande demande) {
    final userService = Provider.of<UserService>(context, listen: false);
    final parcelleService =
        Provider.of<ParcelleService>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<Map<String, dynamic>?>(
        future: userService.getUserById(
            demande.idDemandeur), // Récupérer les infos du demandeur
        builder: (context, demandeurSnapshot) {
          if (!demandeurSnapshot.hasData) {
            return AlertDialog(
              title: Text('Chargement...'),
              content: Center(child: CircularProgressIndicator()),
            );
          }

          final demandeur = demandeurSnapshot.data!;

          return AlertDialog(
            title: Text('Détails de la demande'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations sur la parcelle
                  Card(
                    child: ListTile(
                      title: Text(
                        'Informations sur la demande',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text('ID Demande: ${demande.id}'),
                          Text(
                              'Numéro de parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
                          Text(
                              'Nom du propriétaire: ${demande.nomProprietaire ?? 'Non renseigné'}'),
                          Text(
                              'Adresse du propriétaire: ${demande.adresseProprietaire ?? 'Non renseignée'}'),
                          Text(
                              'Superficie du terrain: ${demande.superficieTerrain ?? 'Non renseignée'}'),
                          Text(
                              'Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
                          Text(
                              'Numéro de folios: ${demande.numFolios ?? 'Inconnu'}'),
                          Text('Statut: ${demande.statut}'),
                          Text(
                              'Date de soumission: ${demande.dateSoumission?.toLocal().toIso8601String() ?? 'Non renseignée'}'),
                          Text(
                              'Assignée à: ${demande.assigneA ?? 'Non assignée'}'),
                          SizedBox(height: 10),
                          Text(
                            'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Informations sur le demandeur
                  Card(
                    child: ListTile(
                      title: Text(
                        'Informations sur le demandeur',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                              'Nom du demandeur: ${demandeur['nom'] ?? 'Nom non renseigné'}'),
                          Text(
                              'Adresse du demandeur: ${demandeur['adresse'] ?? 'Adresse non renseignée'}'),
                          Text(
                              'Email: ${demandeur['email'] ?? 'Email non renseigné'}'),
                          Text(
                              'Téléphone: ${demandeur['telephone'] ?? 'Téléphone non renseigné'}'),
                          Text(
                              'Numéro CIN ou NINA: ${demandeur['numCINouNINA'] ?? 'Non renseigné'}'),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Boutons pour les actions sur la parcelle
                  ElevatedButton(
                    onPressed: () async {
                      await verifierEtAfficherResultats(
                          context, demande); // Vérification et affichage
                    },
                    child: Text('Vérifier les informations'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Méthode pour vérifier les informations soumises et afficher les résultats
  Future<void> verifierEtAfficherResultats(
      BuildContext context, Demande demande) async {
    final parcelleService =
        Provider.of<ParcelleService>(context, listen: false);
    final demandeService = Provider.of<DemandeService>(context, listen: false);

    String reponse = ''; // Initialisation de la réponse
    List<String> differences = [];
    bool litigePresent = false;
    List<String> historiqueTransactions = [];

    try {
      // Vérification du numéro de parcelle
      if (demande.numParcelle == null || demande.numParcelle == '') {
        reponse = 'Numéro de parcelle manquant ou invalide.';
        await demandeService.repondreDemande(demande.id, reponse);
        await demandeService.updateStatutDemande(demande.id, 'Répondu');
        return;
      }

      final int numParcelle =
          int.tryParse(demande.numParcelle.toString()) ?? -1;
      if (numParcelle == -1) {
        reponse = 'Le numéro de parcelle est incorrect ou invalide.';
        await demandeService.repondreDemande(demande.id, reponse);
        await demandeService.updateStatutDemande(demande.id, 'Répondu');
        return;
      }

      // Récupération des informations de la parcelle
      final parcelleData =
          await parcelleService.getParcelleByNumero(numParcelle);

      if (parcelleData != null) {
        // Si les types de demande sont bien récupérés
        if (demande.typesDemande != null && demande.typesDemande!.isNotEmpty) {
          for (String typeDemande in demande.typesDemande!) {
            // Gestion du type 'Vérification titre de propriété'
            if (typeDemande == 'Vérification titre de propriété') {
              if (demande.nomProprietaire != parcelleData['nomProprietaire']) {
                differences.add('Nom incorrect');
              }
              if (demande.adresseProprietaire !=
                  parcelleData['adresseProprietaire']) {
                differences.add('Adresse incorrecte');
              }
              if (demande.superficieTerrain !=
                  parcelleData['superficieTerrain']) {
                differences.add('Superficie incorrecte');
              }
              if (demande.lieuParcelle != parcelleData['lieuParcelle']) {
                differences.add('Lieu incorrect');
              }
            }

            // Gestion du type 'Historique de transaction foncière'
            if (typeDemande == 'Historique de transaction foncière') {
              historiqueTransactions =
                  parcelleData['historiqueTransactions']?.cast<String>() ?? [];
            }

            // Gestion du type 'Litige foncier'
            if (typeDemande == 'Litige foncier') {
              litigePresent = parcelleData['litige'] ?? false;
            }
          }

          // Affichage des résultats dans une nouvelle fenêtre
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Résultats de la vérification'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Résultats de la vérification du titre de propriété
                    if (demande.typesDemande!
                        .contains('Vérification titre de propriété'))
                      Card(
                        child: ListTile(
                          title: Text(
                            'Vérification titre de propriété',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(differences.isEmpty
                              ? 'Toutes les informations correspondent.'
                              : 'Incohérences trouvées : ${differences.join(', ')}'),
                        ),
                      ),

                    SizedBox(height: 16),

                    // Résultats de l'historique des transactions
                    if (demande.typesDemande!
                        .contains('Historique de transaction foncière'))
                      Card(
                        child: ExpansionTile(
                          title: Text(
                            'Historique des transactions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: historiqueTransactions.isNotEmpty
                              ? historiqueTransactions.map((transaction) {
                                  return ListTile(
                                    title: Text(transaction),
                                  );
                                }).toList()
                              : [
                                  ListTile(
                                    title: Text('Aucun historique trouvé.'),
                                  ),
                                ],
                        ),
                      ),

                    SizedBox(height: 16),

                    // Résultats de la vérification des litiges
                    if (demande.typesDemande!.contains('Litige foncier'))
                      Card(
                        child: ListTile(
                          title: Text(
                            'Litige foncier',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(litigePresent
                              ? 'Un litige est présent sur cette parcelle.'
                              : 'Aucun litige trouvé sur cette parcelle.'),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Envoi de la réponse et mise à jour du statut
                    reponse = genererReponse(
                        differences, historiqueTransactions, litigePresent);
                    await demandeService.repondreDemande(demande.id, reponse);
                    await demandeService.updateStatutDemande(
                        demande.id, 'Répondu');

                    // Fermer les boîtes de dialogue
                    Navigator.of(ctx)
                        .pop(); // Fermer la boîte de dialogue actuelle
                    Navigator.of(context)
                        .pop(); // Fermer la boîte de dialogue précédente

                    // Afficher un message de confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Réponse envoyée avec succès')),
                    );
                  },
                  child: Text('Envoyer la réponse'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            ),
          );
        } else {
          // Si aucun type de demande n'est trouvé dans la demande
          reponse = 'Aucun type de demande valide trouvé dans la demande.';
          await demandeService.repondreDemande(demande.id, reponse);
          await demandeService.updateStatutDemande(demande.id, 'Répondu');
        }
      } else {
        // Si la parcelle n'est pas trouvée, envoyer une réponse appropriée
        reponse = 'Le numéro de parcelle fourni est incorrect ou introuvable.';
        await demandeService.repondreDemande(demande.id, reponse);
        await demandeService.updateStatutDemande(demande.id, 'Répondu');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réponse envoyée : parcelle introuvable')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la vérification : $e')),
      );
    }
  }

  // Méthode pour générer la réponse à envoyer au demandeur
  String genererReponse(List<String> differences,
      List<String> historiqueTransactions, bool litigePresent) {
    String reponse = '';

    // Vérification titre de propriété
    if (differences.isNotEmpty) {
      reponse +=
          '- Incohérences trouvées dans les informations fournies : ${differences.join(', ')}.\n';
    } else {
      reponse +=
          '- Toutes les informations fournies correspondent aux enregistrements.\n';
    }

    // Historique des transactions
    if (historiqueTransactions.isNotEmpty) {
      reponse +=
          '- Historique des transactions : ${historiqueTransactions.join(', ')}.\n';
    } else {
      reponse += '- Aucun historique de transactions trouvé.\n';
    }

    // Litige foncier
    reponse += litigePresent
        ? '- Un litige est présent sur cette parcelle.\n'
        : '- Aucun litige trouvé sur cette parcelle.\n';

    return reponse;
  }
}
