import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/admin/form_assis.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/assistantjuriduque_service.dart';

class AssistantsPage extends StatefulWidget {
  @override
  _AssistantsPageState createState() => _AssistantsPageState();
}

class _AssistantsPageState extends State<AssistantsPage> {
  int _rowsPerPage =
      PaginatedDataTable.defaultRowsPerPage; // Lignes par page par défaut
  int _sortColumnIndex = 0; // Index de la colonne triée
  bool _sortAscending = true; // Détermine si le tri est ascendant ou non

  @override
  Widget build(BuildContext context) {
    final assistantService = Provider.of<AssistantService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurprincipale,
        automaticallyImplyLeading: false,
        title: Text('Liste des Conseils Juridiques'),
        centerTitle: false,
        actions: [
          // Bouton pour ajouter un conseil juridique
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
           
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            assistantService.getAllAssistants(), // Récupère tous les assistants
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Indicateur de chargement
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    'Aucun assistant trouvé.')); // Affiche un message si aucune donnée n'est disponible
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                     mainAxisAlignment: MainAxisAlignment.end, // Aligne tout à droite
                           // Aligne les éléments dans le Row
                     children: [
                        
                        ElevatedButton(
                          onPressed: () {
                            // Naviguer vers la page AddAssistantForm
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddAssistantForm()), // Ici, tu passes la page de formulaire
                            );
                          },
                          child: Text('Ajouter un personnel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: constraints
                                .maxWidth), // Assure que le tableau utilise toute la largeur
                        child: PaginatedDataTable(
                          header: Text(''), // Pas d'en-tête pour le tableau
                          columns:
                              _createColumns(), // Crée les colonnes du tableau
                          source: _AssistantDataSource(
                              snapshot.data!, context), // Source des données
                          rowsPerPage:
                              _rowsPerPage, // Nombre de lignes par page
                          availableRowsPerPage: [
                            5,
                            10,
                            20
                          ], // Options pour le nombre de lignes par page
                          onRowsPerPageChanged: (value) {
                            setState(() {
                              _rowsPerPage = value ??
                                  _rowsPerPage; // Met à jour le nombre de lignes par page
                            });
                          },
                          sortColumnIndex:
                              _sortColumnIndex, // Colonne utilisée pour le tri
                          sortAscending:
                              _sortAscending, // Détermine si le tri est ascendant
                          onSelectAll: (isSelected) {
                            setState(
                                () {}); // Gère la sélection de toutes les lignes
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

  // Création des colonnes du tableau des assistants juridiques
  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Text('Nom'),
          onSort: (index, ascending) {
            setState(() {
              _sortColumnIndex = index; // Met à jour la colonne triée
              _sortAscending = ascending; // Met à jour l'ordre de tri
            });
          }),
      DataColumn(label: Text('Adresse')),
      DataColumn(label: Text('Contact')),
      DataColumn(label: Text('Popularité')),
      DataColumn(label: Text('Actions')),
    ];
  }
}

// Source des données pour le tableau paginé des assistants
class _AssistantDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _assistants;
  final BuildContext _context;

  _AssistantDataSource(this._assistants, this._context);

  @override
  DataRow? getRow(int index) {
    if (index >= _assistants.length)
      return null; // Si l'index dépasse la taille de la liste
    final assistant = _assistants[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(
          assistant['name'] ?? 'Nom inconnu')), // Affiche le nom de l'assistant
      DataCell(Text(
          assistant['adresse'] ?? 'Adresse inconnue')), // Affiche l'adresse
      DataCell(Text(
          assistant['contact'] ?? 'Contact inconnu')), // Affiche le contact
      DataCell(Row(
        // Affiche la popularité sous forme d'étoiles
        children: List.generate(5, (index) {
          return Icon(
            index < (assistant['popularity'] ?? 0)
                ? Icons.star
                : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      )),
      DataCell(Row(
        // Affiche les actions disponibles (édition, suppression)
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                _context,
                MaterialPageRoute(
                  builder: (context) => EditAssistantForm(
                      assistant:
                          assistant), // Navigue vers le formulaire d'édition
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await Provider.of<AssistantService>(_context, listen: false)
                  .deleteAssistant(assistant['id']); // Supprime l'assistant
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate =>
      false; // Le nombre de lignes n'est pas approximatif

  @override
  int get rowCount =>
      _assistants.length; // Retourne le nombre total d'assistants

  @override
  int get selectedRowCount => 0; // Aucune ligne sélectionnée par défaut
}


class EditAssistantForm extends StatelessWidget {
  final Map<String, dynamic> assistant;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _popularityController = TextEditingController();

  EditAssistantForm({required this.assistant}) {
    _nameController.text = assistant['name'] ?? 'Nom inconnu';
    _adresseController.text = assistant['adresse'] ?? 'Adresse inconnue';
    _contactController.text = assistant['contact'] ?? 'Contact inconnu';
    _popularityController.text = (assistant['popularity'] ?? 0).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'Assistant Juridique'),
        backgroundColor: couleurprincipale,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom de l\'assistant',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _adresseController,
              decoration: InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                labelText: 'Contact',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _popularityController,
              decoration: InputDecoration(
                labelText: 'Cote de Popularité (1-5)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: couleurprincipale,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                await AssistantService().updateAssistant(
                  assistant['id'],
                  _nameController.text,
                  _adresseController.text,
                  _contactController.text,
                  int.tryParse(_popularityController.text) ?? 0,
                );
                Navigator.pop(context); // Retour après modification
              },
              child: Text('Modifier Assistant'),
            ),
          ],
        ),
      ),
    );
  }
}
