import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/services/dem_conseil_serv.dart';

class ConseilsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final conseilService = Provider.of<ConseilService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CONSEILS',
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: conseilService.getAllAssistants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun conseil disponible.'));
          }

          // Utiliser LayoutBuilder pour adapter la mise en page selon la taille de l'écran
          return LayoutBuilder(
            builder: (context, constraints) {
              // Ajuster le nombre de colonnes en fonction de la largeur de l'écran
              int crossAxisCount;
              double childAspectRatio;

              if (constraints.maxWidth >= 1200) {
                crossAxisCount = 4; // Grand écran (desktop)
                childAspectRatio = 0.8;
              } else if (constraints.maxWidth >= 800) {
                crossAxisCount = 3; // Tablette
                childAspectRatio = 0.8;
              } else if (constraints.maxWidth >= 600) {
                crossAxisCount = 2; // Petit tablette / paysage mobile
                childAspectRatio = 0.7;
              } else {
                crossAxisCount = 1; // Mobile
                childAspectRatio = 0.9;
              }

              return Padding(
                padding: const EdgeInsets.all(8.0), // Marges réduites
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final conseil = snapshot.data![index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.business,
                                    color: Colors.purple, size: 20),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    conseil['nom'] ?? 'Nom inconnu',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.grey, size: 18),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Adresse: ${conseil['adresse'] ?? 'Non spécifiée'}',
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.grey, size: 18),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Contact: ${conseil['contact'] ?? 'Non spécifié'}',
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Popularité:',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < (conseil['popularity'] ?? 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              }),
                            ),
                            Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showConseilDetails(context, conseil);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Voir plus',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fonction pour afficher les détails du conseil juridique
  void showConseilDetails(BuildContext context, Map<String, dynamic> conseil) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(conseil['nom']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Adresse: ${conseil['adresse']}'),
            Text('Contact: ${conseil['contact']}'),
            Text('Popularité: ${conseil['popularity']} / 5'),
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
