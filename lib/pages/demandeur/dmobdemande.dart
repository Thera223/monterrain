import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/services/demande_ser.dart';

class DemandePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Utilisateur connecté
    final demandeService = Provider.of<DemandeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Demandes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Demande>>(
        future: demandeService.getDemandesByUser(user!.uid),
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

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ListTile(
                      leading: Icon(Icons.insert_drive_file_rounded),
                      title: Text(
                        'Nº Parcelle: ${demande.numParcelle ?? 'Inconnu'}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              SizedBox(width: 4),
                              Text(demande.dateSoumission != null
                                  ? '${demande.dateSoumission!.toLocal()}'
                                  : 'Date inconnue'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('Statut: ${demande.statut}'),
                          SizedBox(height: 4),
                          Text(
                              'Nom Propriétaire: ${demande.nomProprietaire ?? 'Inconnu'}'),
                          SizedBox(height: 4),
                          Text(
                              'Adresse Propriétaire: ${demande.adresseProprietaire ?? 'Inconnue'}'),
                          SizedBox(height: 4),
                          Text(
                              'Superficie: ${demande.superficieTerrain ?? 'Inconnue'}'),
                          SizedBox(height: 4),
                          Text(
                              'Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          showDetails(context, demande);
                        },
                      ),
                    )


                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/submit-demande');
        },
        child: Icon(Icons.add),
      ),
    );
  }

void showDetails(BuildContext context, Demande demande) {
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
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }












  // Affichage d'une boîte de dialogue pour la réponse
  void showResponseDialog(BuildContext context, Demande demande) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Réponse à la demande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Réponse: ${demande.reponse ?? 'Aucune réponse'}'),
         
          ],
        ),
        actions: [
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

}