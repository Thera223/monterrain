import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/services/user_service.dart';


class AdminDemandesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demandeService = Provider.of<DemandeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toutes les Demandes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Demande>>(
        future: demandeService.getAllDemandes(), // Appel à getAllDemandes()
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune demande disponible.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final demande = snapshot.data![index];
              return ListTile(
                title: Text('Demande Nº ${demande.numParcelle ?? 'Inconnue'}'),
                subtitle: Text('Statut: ${demande.statut ?? 'En attente'}'),
                trailing: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    showDetails(context, demande);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fonction pour afficher les détails de la demande
void showDetails(BuildContext context, Demande demande) {
  final userService = Provider.of<UserService>(context, listen: false);

  showDialog(
    context: context,
    builder: (ctx) => FutureBuilder<Map<String, dynamic>?>(
      future: userService.getUserById(demande.idDemandeur), // Récupérer les infos du demandeur
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
                // Section Demande
                Text('--- Informations sur la demande ---', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('ID Demande: ${demande.id}'),
                Text('Numéro de parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
                Text('Nom du propriétaire: ${demande.nomProprietaire ?? 'Non renseigné'}'),
                Text('Adresse du propriétaire: ${demande.adresseProprietaire ?? 'Non renseignée'}'),
                Text('Superficie du terrain: ${demande.superficieTerrain ?? 'Non renseignée'}'),
                Text('Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
                Text('Numéro de folios: ${demande.numFolios ?? 'Inconnu'}'),
                Text('Statut: ${demande.statut}'),
                Text('Date de soumission: ${demande.dateSoumission?.toLocal().toIso8601String() ?? 'Non renseignée'}'),
                Text('Assignée à: ${demande.assigneA ?? 'Non assignée'}'),
                SizedBox(height: 10),

                // Types de demande
                Text('Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
                SizedBox(height: 10),

                // Réponse à la demande
                Text('Réponse: ${demande.reponse ?? 'Pas encore de réponse'}'),
                Divider(),
                
                // Section Demandeur
                Text('--- Informations sur le demandeur ---', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Nom du demandeur: ${demandeur['nom'] ?? 'Nom non renseigné'}'),
                Text('Adresse du demandeur: ${demandeur['adresse'] ?? 'Adresse non renseignée'}'),
                Text('Email: ${demandeur['email'] ?? 'Email non renseigné'}'),
                Text('Téléphone: ${demandeur['telephone'] ?? 'Téléphone non renseigné'}'),
                Text('Numéro CIN ou NINA: ${demandeur['numCINouNINA'] ?? 'Non renseigné'}'),
                SizedBox(height: 10),
                
                // Informations supplémentaires possibles
                Text('Autres informations:'),
                demandeur.containsKey('autresInfos')
                    ? Text(demandeur['autresInfos'])
                    : Text('Aucune autre information disponible'),
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
}