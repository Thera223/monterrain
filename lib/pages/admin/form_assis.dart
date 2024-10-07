import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:terrain/services/assistantjuriduque_service.dart';

class AddAssistantForm extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _popularityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final assistantService =
        Provider.of<AssistantService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Assistant Juridique'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom de l\'assistant'),
            ),
            TextField(
              controller: _adresseController,
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            TextField(
              controller: _popularityController,
              decoration:
                  InputDecoration(labelText: 'Cote de Popularité (1-5)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await assistantService.addAssistant(
                  _nameController.text,
                  _adresseController.text,
                  _contactController.text,
                  int.tryParse(_popularityController.text) ?? 0,
                );
                Navigator.pop(context); // Retour après ajout
              },
              child: Text('Ajouter Assistant'),
            ),
          ],
        ),
      ),
    );
  }
}
