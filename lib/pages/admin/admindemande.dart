import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/services/user_service.dart';

class AdminDemandesPage extends StatefulWidget {
  @override
  _AdminDemandesPageState createState() => _AdminDemandesPageState();
}

class _AdminDemandesPageState extends State<AdminDemandesPage> {
  int _rowsPerPage = PaginatedDataTable
      .defaultRowsPerPage; // Nombre de lignes par page par défaut
  int _sortColumnIndex = 0; // Index de la colonne par laquelle trier
  bool _sortAscending = true; // Détermine si le tri est ascendant ou descendant

  @override
  Widget build(BuildContext context) {
    final demandeService =
        Provider.of<DemandeService>(context); // Accès au service des demandes

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Toutes les Demandes',
            ),
        backgroundColor: couleurprincipale,
        centerTitle: false, // Centrer le titre de l'appBar
      ),
      body: FutureBuilder<List<Demande>>(
        future: demandeService.getAllDemandes(), // Récupère toutes les demandes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Affiche un indicateur de chargement
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    'Aucune demande trouvée.')); // Affiche un message si aucune donnée
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Aligner les éléments du row
                      children: [
                        
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: constraints
                                .maxWidth), // Assure que le tableau s'étend sur toute la largeur
                        child: PaginatedDataTable(
                          header: Text(''), // En-tête du tableau
                          columns:
                              _createColumns(), // Appelle la fonction pour créer les colonnes
                          source: _DemandeDataSource(snapshot.data!,
                              context), // Source des données pour le tableau
                          rowsPerPage:
                              _rowsPerPage, // Définir le nombre de lignes par page
                          availableRowsPerPage: [
                            5,
                            10,
                            20
                          ], // Options de sélection pour le nombre de lignes par page
                          onRowsPerPageChanged: (value) {
                            setState(() {
                              _rowsPerPage = value ??
                                  _rowsPerPage; // Mise à jour du nombre de lignes par page sélectionné
                            });
                          },
                          sortColumnIndex:
                              _sortColumnIndex, // Colonne utilisée pour trier
                          sortAscending:
                              _sortAscending, // Tri ascendant ou descendant
                          onSelectAll: (isSelected) {
                            setState(
                                () {}); // Action lorsque toutes les lignes sont sélectionnées
                          },
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
    );
  }

  // Crée les colonnes du tableau des demandes
  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Text('Numéro de Parcelle'),
          onSort: (index, ascending) {
            setState(() {
              _sortColumnIndex =
                  index; // Met à jour l'index de la colonne triée
              _sortAscending = ascending; // Met à jour l'ordre du tri
            });
          }),
      DataColumn(label: Text('Statut')), // Colonne pour le statut de la demande
      DataColumn(
          label: Text(
              'Nom du Propriétaire')), // Colonne pour le nom du propriétaire
      DataColumn(
          label: Text('Actions')), // Colonne pour les actions disponibles
    ];
  }
}

// Classe qui génère les lignes du tableau pour chaque demande
class _DemandeDataSource extends DataTableSource {
  final List<Demande> _demandes; // Liste des demandes récupérées
  final BuildContext _context;

  _DemandeDataSource(this._demandes, this._context);

  @override
  DataRow? getRow(int index) {
    if (index >= _demandes.length)
      return null; // Si l'index dépasse la longueur de la liste
    final demande = _demandes[index]; // Récupère la demande actuelle

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(
          demande.numParcelle ?? 'Inconnue')), // Affiche le numéro de parcelle
      DataCell(Text(
          demande.statut ?? 'En attente')), // Affiche le statut de la demande
      DataCell(Text(demande.nomProprietaire ??
          'Non renseigné')), // Affiche le nom du propriétaire
      DataCell(Row(
        // Cellule contenant les boutons d'action
        children: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.blueAccent),
            onPressed: () {
              _showDetails(
                  _context, demande); // Affiche les détails de la demande
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate =>
      false; // Indique que le nombre de lignes n'est pas approximatif

  @override
  int get rowCount => _demandes.length; // Retourne le nombre de demandes

  @override
  int get selectedRowCount => 0; // Aucune ligne n'est sélectionnée par défaut

  // Fonction pour afficher les détails d'une demande
  void _showDetails(BuildContext context, Demande demande) {
    final userService = Provider.of<UserService>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<Map<String, dynamic>?>(
        future: userService.getUserById(
            demande.idDemandeur), // Récupère les informations du demandeur
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return AlertDialog(
              title: Text('Chargement...'),
              content: Center(
                  child:
                      CircularProgressIndicator()), // Affiche un indicateur de chargement
            );
          }
          final demandeur = snapshot.data!; // Détails du demandeur
          return AlertDialog(
            title: Text('Détails de la demande'),
            content: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligne les éléments à gauche
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
                Text(
                    'Lieu de la Parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
                Text('Numéro Folios: ${demande.numFolios ?? 'Inconnu'}'),
                Text(
                    'Date de soumission: ${demande.dateSoumission?.toLocal() ?? 'Inconnue'}'),
                Text('Réponse: ${demande.reponse ?? 'Pas encore de réponse'}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(ctx).pop(), // Ferme la boîte de dialogue
                child: Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }
}
