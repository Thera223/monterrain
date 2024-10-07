import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/admin/form_assis.dart';
import 'package:terrain/services/assistantjuriduque_service.dart';

class AssistantsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final assistantService = Provider.of<AssistantService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Conseils Juridiques'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAssistantForm()),
                );
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'Ajouter un conseil',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: assistantService.getAllAssistants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun assistant trouvé.'));
          }

          // Affichage de la liste des assistants sous forme de tableau personnalisé
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entête du tableau
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.deepPurple[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Nom',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text('Adresse',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text('Contact',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text('Cote de Popularité',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Text('Actions',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 2),

                // Corps du tableau
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final assistant = snapshot.data![index];

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(assistant['name'] ?? 'Nom inconnu'),
                            ),
                            Expanded(
                              child: Text(
                                  assistant['adresse'] ?? 'Adresse inconnue'),
                            ),
                            Expanded(
                              child: Text(
                                  assistant['contact'] ?? 'Contact inconnu'),
                            ),
                            Expanded(
                              child: Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < (assistant['popularity'] ?? 0)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                }),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditAssistantForm(
                                            assistant: assistant),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await assistantService
                                        .deleteAssistant(assistant['id']);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
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
        backgroundColor: Colors.deepPurple,
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
                backgroundColor: Colors.deepPurple,
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
