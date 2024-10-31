// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/model/demande.dart';
// import 'package:terrain/pages/config_charte_coul.dart';
// import 'package:terrain/services/demande_ser.dart';
// import 'package:terrain/widgets/contenudahchef.dart';
// import 'package:pdf/widgets.dart' as pw;

// class DemandePage extends StatefulWidget {
//   @override
//   _DemandePageState createState() => _DemandePageState();
// }

// class _DemandePageState extends State<DemandePage> {
//   int _currentIndex = 1;

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, '/dashboard');
//         break;
//       case 1:
//         Navigator.pushNamed(context, '/demandes');
//         break;
//       case 2:
//         Navigator.pushNamed(context, '/conseils');
//         break;
//       case 3:
//         Navigator.pushNamed(context, '/profil');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final demandeService = Provider.of<DemandeService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: couleurprincipale,
//         title: Text('Mes Demandes'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Demande>>(
//         future: demandeService.getDemandesByUser(user!.uid),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 'Aucune demande disponible.',
//                 style: TextStyle(color: Colors.grey, fontSize: 18),
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final demande = snapshot.data![index];

//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         blurRadius: 4,
//                         spreadRadius: 2,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.insert_drive_file_rounded,
//                       color: couleurprincipale,
//                     ),
//                     title: Text(
//                       'Nº Parcelle: ${demande.numParcelle ?? 'Inconnu'}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(Icons.calendar_today,
//                                 size: 16, color: couleurprincipale),
//                             SizedBox(width: 4),
//                             Text(
//                               demande.dateSoumission != null
//                                   ? '${demande.dateSoumission!.toLocal()}'
//                                   : 'Date inconnue',
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4),
//                         Text('Statut: ${demande.statut}'),
//                         Text(
//                             'Nom Propriétaire: ${demande.nomProprietaire ?? 'Inconnu'}'),
//                         Text(
//                             'Adresse Propriétaire: ${demande.adresseProprietaire ?? 'Inconnue'}'),
//                         Text(
//                             'Superficie: ${demande.superficieTerrain ?? 'Inconnue'}'),
//                         Text(
//                             'Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.info_outline, color: couleurprincipale),
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
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: couleurprincipale,
//         onPressed: () {
//           Navigator.pushNamed(context, '/submit-demande');
//         },
//         child: Icon(Icons.add),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _currentIndex,
//         onTabTapped: onTabTapped,
//       ),
//     );
//   }

//   void showDetails(BuildContext context, Demande demande) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Détails de la demande'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('ID Demande: ${demande.id}'),
//               Text('Statut: ${demande.statut}'),
//               SizedBox(height: 8),
//               Text(
//                   'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
//               SizedBox(height: 16),
//               Text('Nom Propriétaire: ${demande.nomProprietaire}'),
//               Text('Adresse Propriétaire: ${demande.adresseProprietaire}'),
//               Text('Superficie Terrain: ${demande.superficieTerrain}'),
//               Text('Lieu de la Parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
//               Text('Numéro Folios: ${demande.numFolios ?? 'Inconnu'}'),
//               Text(
//                   'Date de soumission: ${demande.dateSoumission?.toLocal() ?? 'Inconnue'}'),
//               Text('Réponse: ${demande.reponse ?? 'Pas encore de réponse'}'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await _generatePDF(demande);
//             },
//             child: Text('Télécharger en PDF'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Fermer'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _generatePDF(Demande demande) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('Détails de la demande', style: pw.TextStyle(fontSize: 24)),
//             pw.SizedBox(height: 16),
//             pw.Text('ID Demande: ${demande.id}'),
//             pw.Text('Statut: ${demande.statut}'),
//             pw.Text(
//                 'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
//             pw.Text('Nom Propriétaire: ${demande.nomProprietaire}'),
//             pw.Text('Adresse Propriétaire: ${demande.adresseProprietaire}'),
//             pw.Text('Superficie Terrain: ${demande.superficieTerrain}'),
//             pw.Text(
//                 'Lieu de la Parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
//             pw.Text('Numéro Folios: ${demande.numFolios ?? 'Inconnu'}'),
//             pw.Text(
//                 'Date de soumission: ${demande.dateSoumission?.toLocal() ?? 'Inconnue'}'),
//             pw.Text('Réponse: ${demande.reponse ?? 'Pas encore de réponse'}'),
//           ],
//         ),
//       ),
//     );

//     try {
//       // Demander l'autorisation de stockage
//       if (await Permission.storage.request().isGranted) {
//         // Récupérer le chemin pour stocker le fichier
//         final output = await getTemporaryDirectory();
//         final file = File("${output.path}/demande_${demande.id}.pdf");

//         // Sauvegarder le PDF
//         await file.writeAsBytes(await pdf.save());

//         // Informer l'utilisateur que le PDF a été téléchargé
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('PDF téléchargé : ${file.path}')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Permission de stockage refusée')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur lors du téléchargement du PDF : $e')),
//       );
//     }
//   }
// }


import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/widgets/contenudahchef.dart';
import 'package:pdf/widgets.dart' as pw;

class DemandePage extends StatefulWidget {
  @override
  _DemandePageState createState() => _DemandePageState();
}

class _DemandePageState extends State<DemandePage> {
  int _currentIndex = 1;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/demandes');
        break;
      case 2:
        Navigator.pushNamed(context, '/conseils');
        break;
      case 3:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final demandeService = Provider.of<DemandeService>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: couleurprincipale,
        title: Text('DEMANDES',  style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
        
        centerTitle: true,
      ),
      body: FutureBuilder<List<Demande>>(
        future: demandeService.getDemandesByUser(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucune demande disponible.',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
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
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.location_on,
                            color: Colors.blue, size: 30),
                        title: Text(
                          'Nº Terrain ${demande.numParcelle ?? 'Inconnu'}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 14, color: Colors.grey),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    demande.dateSoumission != null
                                        ? '${demande.dateSoumission!.toLocal()}'
                                        : 'Date inconnue',
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 14, color: Colors.grey),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '14:00 PM - 16:00 PM',
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                onPressed: demande.statut == 'Répondu'
                                    ? () {
                                        showDetailsd(context, demande);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFECEAFF),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  minimumSize: Size(120, 36), // Taille minimale
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Voir réponse',
                                  style: TextStyle(
                                    color: demande.statut == 'Répondu'
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: demande.statut == 'Répondu'
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                demande.statut == 'Répondu'
                                    ? 'Réponse dispo'
                                    : 'Réponse indispo',
                                style: TextStyle(
                                  color: demande.statut == 'Répondu'
                                      ? Colors.blue
                                      : Colors.red,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: IconButton(
                                icon: Icon(Icons.info_outline,
                                    color: couleurprincipale),
                                iconSize:
                                    20, // Ajustement de la taille de l'icône
                                onPressed: () {
                                  showDetailsd(context, demande);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );


        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: couleurprincipale,
        onPressed: () {
          Navigator.pushNamed(context, '/submit-demande');
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
  void showDetailsd(BuildContext context, Demande demande) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Détails de la demande'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Demande: ${demande.id}'),
              Text('Statut: ${demande.statut}'),
              SizedBox(height: 8),
              Text(
                  'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
              SizedBox(height: 16),
              Text('Nom Propriétaire: ${demande.nomProprietaire}'),
              Text('Adresse Propriétaire: ${demande.adresseProprietaire}'),
              Text('Superficie Terrain: ${demande.superficieTerrain}'),
              Text('Lieu de la Parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
              Text('Numéro Folios: ${demande.numFolios ?? 'Inconnu'}'),
              Text(
                  'Date de soumission: ${demande.dateSoumission?.toLocal() ?? 'Inconnue'}'),
              Text('Réponse: ${demande.reponse ?? 'Pas encore de réponse'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _generatePDF(demande);
            },
            child: Text('Télécharger en PDF'),
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
  }

  Future<void> _generatePDF(Demande demande) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Détails de la demande', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('ID Demande: ${demande.id}'),
            pw.Text('Statut: ${demande.statut}'),
            pw.Text(
                'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
            pw.Text('Nom Propriétaire: ${demande.nomProprietaire}'),
            pw.Text('Adresse Propriétaire: ${demande.adresseProprietaire}'),
            pw.Text('Superficie Terrain: ${demande.superficieTerrain}'),
            pw.Text(
                'Lieu de la Parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
            pw.Text('Numéro Folios: ${demande.numFolios ?? 'Inconnu'}'),
            pw.Text(
                'Date de soumission: ${demande.dateSoumission?.toLocal() ?? 'Inconnue'}'),
            pw.Text('Réponse: ${demande.reponse ?? 'Pas encore de réponse'}'),
          ],
        ),
      ),
    );

    try {
      // Demander l'autorisation de stockage
      if (await Permission.storage.request().isGranted) {
        // Récupérer le chemin pour stocker le fichier
        final output = await getTemporaryDirectory();
        final file = File("${output.path}/demande_${demande.id}.pdf");

        // Sauvegarder le PDF
        await file.writeAsBytes(await pdf.save());

        // Informer l'utilisateur que le PDF a été téléchargé
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF téléchargé : ${file.path}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission de stockage refusée')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du téléchargement du PDF : $e')),
      );
    }
  }
}
