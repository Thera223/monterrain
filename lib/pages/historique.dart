// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/services/hist_service.dart';

// class LogsPage extends StatefulWidget {
//   @override
//   _LogsPageState createState() => _LogsPageState();
// }

// class _LogsPageState extends State<LogsPage> {
//   String selectedAction = 'Toutes'; // Action sélectionnée par défaut

//   @override
//   Widget build(BuildContext context) {
//     final logService = Provider.of<LogService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Historique des actions'),
//       ),
//       body: Column(
//         children: [
//           // Dropdown pour sélectionner l'action à filtrer
//           DropdownButton<String>(
//             value: selectedAction,
//             items: ['Toutes', 'Ajout', 'Modification', 'Suppression','Réponse','Demandes','Assignation']
//                 .map((action) => DropdownMenuItem(
//                       value: action,
//                       child: Text(action),
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedAction = value!;
//               });
//             },
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: logService.getLogsStream(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 final logs = snapshot.data!.docs;

//                 // Filtrer les logs selon l'action sélectionnée
//                 final filteredLogs = selectedAction == 'Toutes'
//                     ? logs
//                     : logs.where((log) {
//                         return log['action'] == selectedAction;
//                       }).toList();

//                 return ListView.builder(
//                   itemCount: filteredLogs.length,
//                   itemBuilder: (context, index) {
//                     final log = filteredLogs[index];
//                     return ListTile(
//                       title: Text('Action: ${log['action']}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Détails: ${log['details']}'),
//                           Text('Utilisateur: ${log['userId']}'),
//                           Text('Rôle: ${log['role']}'),
//                         ],
//                       ),
//                       trailing: Text(
//                         (log['timestamp'] as Timestamp).toDate().toString(),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/hist_service.dart';

class LogsPage extends StatefulWidget {
  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String selectedAction = 'Toutes'; // Action sélectionnée par défaut
  int _rowsPerPage = 10; // Nombre de lignes par page
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final logService = Provider.of<LogService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurprincipale,
        automaticallyImplyLeading: false,
        title: Text('Historique des actions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espacement autour de la table
        child: StreamBuilder<QuerySnapshot>(
          stream: logService.getLogsStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final logs = snapshot.data!.docs;

            // Filtrer les logs selon l'action sélectionnée
            final filteredLogs = selectedAction == 'Toutes'
                ? logs
                : logs.where((log) {
                    return log['action'] == selectedAction;
                  }).toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Dropdown pour sélectionner l'action à filtrer
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal:
                              8.0), // Ajout de padding pour un bon espacement
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Espace entre les éléments
                        children: [
                          // DropdownButton bien stylisé avec une bordure
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 1), // Bordure grise
                              borderRadius:
                                  BorderRadius.circular(8.0), // Coins arrondis
                            ),
                            child: DropdownButtonHideUnderline(
                              // Cache la ligne sous le DropdownButton
                              child: DropdownButton<String>(
                                value: selectedAction,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.blueAccent), // Icône à droite
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        16), // Style du texte dans le Dropdown
                                items: [
                                  'Toutes',
                                  'Ajout',
                                  'Modification',
                                  'Suppression',
                                  'Réponse',
                                  'Demandes',
                                  'Assignation'
                                ]
                                    .map((action) => DropdownMenuItem(
                                          value: action,
                                          child:
                                              Text(action), // Texte des options
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedAction = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical, // Défilement vertical
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Défilement horizontal
                          child: SizedBox(
                            width: constraints
                                .maxWidth, // Prendre toute la largeur de l'écran
                            child: PaginatedDataTable(
                              header:
                                  Text(''), // En-tête vide pour un design épuré
                              columns:
                                  _createColumns(), // Création des colonnes
                              source: LogDataSource(
                                  filteredLogs), // Source des données
                              rowsPerPage:
                                  _rowsPerPage, // Nombre de lignes par page
                              availableRowsPerPage: [
                                5,
                                10,
                                20
                              ], // Options de pagination
                              onRowsPerPageChanged: (value) {
                                setState(() {
                                  _rowsPerPage = value ?? _rowsPerPage;
                                });
                              },
                              sortColumnIndex:
                                  _sortColumnIndex, // Colonne pour le tri
                              sortAscending: _sortAscending, // Ordre de tri
                              showCheckboxColumn:
                                  false, // Pas de colonne de sélection
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Création des colonnes pour la table
  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Action')),
      DataColumn(label: Text('Détails')),
      DataColumn(label: Text('Utilisateur')),
      DataColumn(label: Text('Rôle')),
      DataColumn(
        label: Text('Date'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortColumnIndex = columnIndex;
            _sortAscending = ascending;
            // Ajoutez la logique pour trier vos données ici si nécessaire
          });
        },
      ),
    ];
  }
}

// Classe DataTableSource personnalisée pour la pagination
class LogDataSource extends DataTableSource {
  final List<QueryDocumentSnapshot> logs;

  LogDataSource(this.logs);

  @override
  DataRow getRow(int index) {
    final log = logs[index];

    return DataRow(
      cells: [
        DataCell(Text(log['action'] ?? '', style: TextStyle(fontSize: 14))),
        DataCell(Text(log['details'] ?? '', style: TextStyle(fontSize: 14))),
        DataCell(Text(log['userId'] ?? '', style: TextStyle(fontSize: 14))),
        DataCell(Text(log['role'] ?? '', style: TextStyle(fontSize: 14))),
        DataCell(Text((log['timestamp'] as Timestamp).toDate().toString(),
            style: TextStyle(fontSize: 14))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => logs.length;

  @override
  int get selectedRowCount => 0;
}

