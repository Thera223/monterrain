import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/services/hist_service.dart';
import 'package:terrain/services/user_service.dart';

class ChefPersonnelDemandesPage extends StatefulWidget {
  @override
  _ChefPersonnelDemandesPageState createState() =>
      _ChefPersonnelDemandesPageState();
}

class _ChefPersonnelDemandesPageState extends State<ChefPersonnelDemandesPage> {
  int _rowsPerPage =
      PaginatedDataTable.defaultRowsPerPage; // Lignes par page par défaut
  int _sortColumnIndex = 0; // Colonne par défaut pour le tri
  bool _sortAscending = true; // Tri ascendant par défaut

  @override
  Widget build(BuildContext context) {
    final demandeService = Provider.of<DemandeService>(context);
    final userService = Provider.of<UserService>(context);
    final logService = Provider.of<LogService>(context, listen: false);
    final currentUser =
        FirebaseAuth.instance.currentUser;
         // Obtenir l'utilisateur actuel

    if (currentUser == null) {
      return Center(child: Text('Utilisateur non connecté.'));
    }

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          'Demandes de ma localité',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white),
        ),
        centerTitle: true,
        // backgroundColor: couleurprincipale,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<String?>(
        future: userService.getLocaliteByRole(
            currentUser.uid), // Récupère la localité du chef de personnel
        builder: (context, localiteSnapshot) {
          if (localiteSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!localiteSnapshot.hasData || localiteSnapshot.data == null) {
            return Center(child: Text('Localité non définie.'));
          }

          final localite = localiteSnapshot.data!;

          // Une fois la localité obtenue, on récupère les demandes
          return FutureBuilder<List<Demande>>(
            future: demandeService
                .getDemandesByLocalite(localite), // Demandes par localité
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucune demande disponible.'));
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Liste des demandes',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
                            child: PaginatedDataTable(
                              header: Text(''), // En-tête du tableau
                              columns:
                                  _createColumns(), // Crée les colonnes du tableau
                              source: _DemandesDataSource(snapshot.data!,
                                  context, logService), // Source des données
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
                                  _sortColumnIndex, // Colonne utilisée pour le tri
                              sortAscending:
                                  _sortAscending, // Détermine si le tri est ascendant
                              onSelectAll: (isSelected) {
                                setState(() {});
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
          );
        },
      ),
    );
  }

  // Création des colonnes du tableau
  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Numéro de Parcelle')),
      DataColumn(label: Text('Statut')),
      DataColumn(label: Text('Actions')),
    ];
  }
}

// Source des données pour le tableau des demandes
class _DemandesDataSource extends DataTableSource {
  final List<Demande> _demandes;
  final BuildContext _context;
  final LogService logService;

  _DemandesDataSource(this._demandes, this._context, this.logService);

  @override
  DataRow? getRow(int index) {
    if (index >= _demandes.length) return null;
    final demande = _demandes[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(demande.numParcelle ??
          'Inconnue')), // Affiche le numéro de la parcelle
      DataCell(Text(
          demande.statut ?? 'En attente')), // Affiche le statut de la demande
      DataCell(Row(
        children: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Voir détails') {
                _showDetails(
                    _context, demande); // Affiche les détails de la demande
              } else if (value == 'Assigner') {
                assignerDemande(
                    _context, demande, logService); // Assigne la demande à un personnel
              } else if (value == 'Voir réponse') {
                voirReponse(
                    _context, demande); // Affiche la réponse à la demande
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Voir détails', child: Text('Voir détails')),
              PopupMenuItem(
                  value: 'Assigner', child: Text('Assigner à un personnel')),
              PopupMenuItem(value: 'Voir réponse', child: Text('Voir réponse')),
            ],
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate =>
      false; // Le nombre de lignes n'est pas approximatif

  @override
  int get rowCount => _demandes.length; // Retourne le nombre de demandes

  @override
  int get selectedRowCount => 0; // Aucune ligne sélectionnée par défaut

  // Affichage des détails d'une demande
  void _showDetails(BuildContext context, Demande demande) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Détails de la demande'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Numéro de parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
              Text(
                  'Nom du propriétaire: ${demande.nomProprietaire ?? 'Non renseigné'}'),
              Text(
                  'Adresse du propriétaire: ${demande.adresseProprietaire ?? 'Non renseignée'}'),
              Text(
                  'Superficie du terrain: ${demande.superficieTerrain ?? 'Non renseignée'}'),
              // Autres détails...
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(), child: Text('Fermer')),
        ],
      ),
    );
  }





// Méthode pour voir la réponse à une demande
  void voirReponse(BuildContext context, Demande demande) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Réponse à la demande'),
          content: Text(demande.reponse ?? 'Aucune réponse disponible'),
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
    );
  }







void assignerDemande(BuildContext context, Demande demande, LogService logService) {
  final userService = Provider.of<UserService>(context, listen: false);
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : Utilisateur non connecté')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (ctx) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: userService.getPersonnelsByChef(currentUser.uid),
        builder: (context, personnelSnapshot) {
          if (personnelSnapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              title: Text('Chargement...'),
              content: Center(child: CircularProgressIndicator()),
            );
          }

          if (!personnelSnapshot.hasData || personnelSnapshot.data!.isEmpty) {
            return AlertDialog(
              title: Text('Aucun personnel trouvé'),
              content: Text('Aucun personnel n\'a été ajouté pour ce chef.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          }

          final personnels = personnelSnapshot.data!;

          return AlertDialog(
            title: Text('Assigner la demande'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: personnels.length,
                itemBuilder: (context, index) {
                  final personnel = personnels[index];
                  final personnelId = personnel['id'];
                  final personnelName = personnel['nom'] ?? personnel['email'];

                  if (personnelId == null || personnelName == null) {
                    // Si l'ID ou le nom du personnel est manquant, on affiche un message d'erreur
                    return ListTile(
                      title: Text('Personnel non valide'),
                      subtitle: Text('Données manquantes'),
                    );
                  }

                  return ListTile(
                    title: Text(personnelName),
                    onTap: () {
                      Provider.of<DemandeService>(context, listen: false)
                          .assignDemande(demande.id, personnelId)
                          .then((_) async {
                        // Afficher un message de succès
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Demande assignée à $personnelName avec succès')),
                        );

                        // Enregistrer l'action dans le log
                        await logService.logAction(
                          action: 'Assignation',
                          details: 'Demande ${demande.id} assignée à $personnelName par ${currentUser.email}',
                          userId: currentUser.uid,
                          role: 'chef_personnel',  // Rôle de l'utilisateur qui assigne la demande
                        );

                        Navigator.of(ctx).pop();
                      }).catchError((error) {
                        // Afficher un message d'erreur
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur lors de l\'assignation de la demande')),
                        );
                      });
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Annuler'),
              ),
            ],
          );
        },
      );
    },
  );
}

}
















