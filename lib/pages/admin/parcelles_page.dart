import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:terrain/model/parcelle_model.dart';
import 'package:terrain/services/parcelle_service.dart';

class ParcellesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Parcelles'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParcelleListPage(),
              ), // Naviguer vers la page des parcelles
            );
          },
          child: Text('Voir Parcelles'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddParcellePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddParcellePage extends StatelessWidget {
  final ParcelleService parcelleService = ParcelleService();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController addresseController = TextEditingController();
  final TextEditingController numParcelleController = TextEditingController();
  final TextEditingController numFoliosController = TextEditingController();
  final TextEditingController superficieController = TextEditingController();
  final TextEditingController lieuController = TextEditingController();
  final TextEditingController planController = TextEditingController();
  final TextEditingController coutMoyenController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Parcelle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom du Propriétaire'),
            ),
            TextField(
              controller: prenomController,
              decoration: InputDecoration(labelText: 'Prénom du Propriétaire'),
            ),
            TextField(
              controller: addresseController,
              decoration: InputDecoration(labelText: 'Adresse du Propriétaire'),
            ),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: numParcelleController,
              decoration:
                  InputDecoration(labelText: 'Numéro de Parcelle ou Titre'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: numFoliosController,
              decoration:
                  InputDecoration(labelText: 'Numéro d’Enregistrement Folios'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: superficieController,
              decoration: InputDecoration(labelText: 'Superficie du Terrain'),
            ),
            TextField(
              controller: lieuController,
              decoration: InputDecoration(labelText: 'Lieu de la Parcelle'),
            ),
            TextField(
              controller: planController,
              decoration:
                  InputDecoration(labelText: 'Lien du Plan de la Parcelle'),
            ),
            TextField(
              controller: coutMoyenController,
              decoration:
                  InputDecoration(labelText: 'Coût Moyen de la Parcelle'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validation simple des champs
                if (nomController.text.isEmpty ||
                    prenomController.text.isEmpty ||
                    latitudeController.text.isEmpty ||
                    longitudeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez remplir tous les champs requis.'),
                    ),
                  );
                  return;
                }

                Parcelle newParcelle = Parcelle(
                  id: '',
                  nomProprietaire: nomController.text,
                  prenomProprietaire: prenomController.text,
                  addresseProprietaire: addresseController.text,
                  numParcelleOuTitre: int.parse(numParcelleController.text),
                  numEnregFolios: int.parse(numFoliosController.text),
                  superficieTerrain: superficieController.text,
                  lieuParcelle: lieuController.text,
                  planParcelle: planController.text,
                  coutMoyenParcelle: coutMoyenController.text,
                  latitude: double.parse(latitudeController.text),
                  longitude: double.parse(longitudeController.text),
                  verification: true, // Par défaut
                  litige: false, // Par défaut
                  historiqueTransactions: [], // Initialement vide
                );
                parcelleService.addParcelle(newParcelle).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Parcelle ajoutée avec succès!')),
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : $error')),
                  );
                });
              },
              child: Text('Ajouter Parcelle'),
            ),
          ],
        ),
      ),
    );
  }
}

class ParcelleListPage extends StatelessWidget {
  final ParcelleService parcelleService = ParcelleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Parcelles'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Parcelle>>(
        future: parcelleService.getAllParcelles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune parcelle trouvée.'));
          } else {
            final parcelles = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Nombre de colonnes
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:
                      2, // Ajuster la hauteur et la largeur des cartes
                ),
                itemCount: parcelles.length,
                itemBuilder: (context, index) {
                  final parcelle = parcelles[index];
                  return ParcelleCard(parcelle: parcelle);
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddParcellePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ParcelleCard extends StatelessWidget {
  final Parcelle parcelle;

  const ParcelleCard({Key? key, required this.parcelle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Petite carte de la parcelle
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(parcelle.latitude,
                      parcelle.longitude), // Coordonnées de la parcelle
                  zoom: 13.0,
                  interactiveFlags:
                      InteractiveFlag.none, // Désactiver l'interaction
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(parcelle.latitude, parcelle.longitude),
                        builder: (ctx) => Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${parcelle.numParcelleOuTitre.toString().padLeft(3, '0')}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    'Nom: ${parcelle.nomProprietaire} ${parcelle.prenomProprietaire}'),
                Text('Superficie: ${parcelle.superficieTerrain} m²'),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      // Action pour voir plus de détails
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ParcelleDetailPage(parcelle: parcelle),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Voir détails'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ParcelleDetailPage extends StatelessWidget {
  final Parcelle parcelle;

  const ParcelleDetailPage({Key? key, required this.parcelle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Parcelle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID de la parcelle: ${parcelle.numParcelleOuTitre}'),
            Text(
                'Nom du propriétaire: ${parcelle.nomProprietaire} ${parcelle.prenomProprietaire}'),
            Text('Adresse: ${parcelle.addresseProprietaire}'),
            Text('Superficie: ${parcelle.superficieTerrain} m²'),
            Text('Lieu: ${parcelle.lieuParcelle}'),
            // Afficher si la parcelle est vérifiée ou en litige
            Text(
                'Vérification: ${parcelle.verification ? 'Valide' : 'Non valide'}'),
            Text('Litige: ${parcelle.litige ? 'Oui' : 'Non'}'),
            SizedBox(height: 10),
            // Historique des transactions
            Text('Historique des transactions:'),
            ...parcelle.historiqueTransactions
                .map((transaction) => Text('- $transaction'))
                .toList(),
          ],
        ),
      ),
    );
  }
}
