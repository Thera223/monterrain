import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/demande.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Pour obtenir l'utilisateur actuel

class ChefPersonnelDemandesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demandeService = Provider.of<DemandeService>(context);
    final userService = Provider.of<UserService>(context);
    final currentUser =
        FirebaseAuth.instance.currentUser; // Obtenir l'utilisateur actuel

    if (currentUser == null) {
      return Center(child: Text('Utilisateur non connecté.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Demandes de ma localité',
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
      body: FutureBuilder<String?>(
        future: userService.getUserRole(), // Récupérer le rôle de l'utilisateur
        builder: (context, roleSnapshot) {
          if (roleSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!roleSnapshot.hasData ||
              roleSnapshot.data == null ||
              roleSnapshot.data != 'chef_personnel') {
            return Center(child: Text('Rôle non défini ou accès refusé.'));
          }

          // Une fois le rôle récupéré, on peut obtenir la localité du chef de personnel
          return FutureBuilder<String?>(
            future: userService.getLocaliteByRole(currentUser.uid), // Passer l'userId ici
            builder: (context, localiteSnapshot) {
              if (localiteSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!localiteSnapshot.hasData || localiteSnapshot.data == null) {
                return Center(child: Text('Localité non définie.'));
              }

              final localite = localiteSnapshot.data!;

              // Une fois la localité obtenue, on peut récupérer les demandes
              return FutureBuilder<List<Demande>>(
                future: demandeService.getDemandesByLocalite(localite),
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
                        title: Text(
                            'Demande Nº ${demande.numParcelle ?? 'Inconnue'}'),
                        subtitle:
                            Text('Statut: ${demande.statut ?? 'En attente'}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Voir détails') {
                              showDetails(context, demande);
                            } else if (value == 'Assigner') {
                              assignerDemande(context, demande);
                            } else if (value == 'Voir réponse') {
                              voirReponse(context, demande);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'Voir détails',
                              child: Text('Voir détails'),
                            ),
                            PopupMenuItem(
                              value: 'Assigner',
                              child: Text('Assigner à un personnel'),
                            ),
                            PopupMenuItem(
                              value: 'Voir réponse',
                              child: Text('Voir réponse'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

void showDetails(BuildContext context, Demande demande) {
    final userService = Provider.of<UserService>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<Map<String, dynamic>?>(
        future: userService.getUserById(
            demande.idDemandeur), // Récupérer les infos du demandeur
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
                  Text('--- Informations sur la demande ---',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('ID Demande: ${demande.id}'),
                  Text(
                      'Numéro de parcelle: ${demande.numParcelle ?? 'Inconnu'}'),
                  Text(
                      'Nom du propriétaire: ${demande.nomProprietaire ?? 'Non renseigné'}'),
                  Text(
                      'Adresse du propriétaire: ${demande.adresseProprietaire ?? 'Non renseignée'}'),
                  Text(
                      'Superficie du terrain: ${demande.superficieTerrain ?? 'Non renseignée'}'),
                  Text(
                      'Lieu de la parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
                  Text('Numéro de folios: ${demande.numFolios ?? 'Inconnu'}'),
                  Text('Statut: ${demande.statut}'),
                  Text(
                      'Date de soumission: ${demande.dateSoumission?.toLocal().toIso8601String() ?? 'Non renseignée'}'),
                  Text('Assignée à: ${demande.assigneA ?? 'Non assignée'}'),
                  SizedBox(height: 20),
                  

                  // Types de demande
                  Text(
                      'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
                  SizedBox(height: 20),


                  Divider(),

                  // Section Demandeur
                  Text('--- Informations sur le demandeur ---',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'Nom du demandeur: ${demandeur['nom'] ?? 'Nom non renseigné'}'),
                  Text(
                      'Adresse du demandeur: ${demandeur['adresse'] ?? 'Adresse non renseignée'}'),
                  Text('Email: ${demandeur['email'] ?? 'Email non renseigné'}'),
                  Text(
                      'Téléphone: ${demandeur['telephone'] ?? 'Téléphone non renseigné'}'),
                  Text(
                      'Numéro CIN ou NINA: ${demandeur['numCINouNINA'] ?? 'Non renseigné'}'),
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









void assignerDemande(BuildContext context, Demande demande) {
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
                    final personnelName =
                        personnel['nom'] ?? personnel['email'];

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
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Demande assignée à $personnelName avec succès')),
                          );
                          Navigator.of(ctx).pop();
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Erreur lors de l\'assignation de la demande')),
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




}