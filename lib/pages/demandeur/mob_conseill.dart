import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/dem_conseil_serv.dart';
import 'package:terrain/widgets/contenudahchef.dart';

class ConseilsPage extends StatefulWidget {
  @override
  _ConseilsPageState createState() => _ConseilsPageState();
}

class _ConseilsPageState extends State<ConseilsPage> {
  int _currentIndex = 2;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/demandes');
        break;
      case 2:
        break; // Déjà sur la page des Conseils
      case 3:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final conseilService = Provider.of<ConseilService>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'CONSEILS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // backgroundColor: couleurprincipale,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: conseilService.getAllAssistants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: couleurprincipale));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucun conseil disponible.',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          // Utiliser LayoutBuilder pour adapter la mise en page selon la taille de l'écran
return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final conseil = snapshot.data![index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            Icon(Icons.business, color: Colors.blue, size: 30),
                        title: Text(
                          conseil['nom'] ?? 'Nom inconnu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            // Adresse du Conseil
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Adresse: ${conseil['adresse'] ?? 'Non spécifiée'}',
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // Contact du Conseil
                            Row(
                              children: [
                                Icon(Icons.phone, size: 14, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Contact: ${conseil['contact'] ?? 'Non spécifié'}',
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Bouton pour voir plus d'infos
                            ElevatedButton(
                              onPressed: () {
                                showConseilDetails(
                                    context, conseil); // Afficher les détails
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFECEAFF),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Voir plus',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Popularité sous forme d'étoiles
                            Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Ajuste la taille en fonction des étoiles
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < (conseil['popularity'] ?? 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 18, // Taille des étoiles
                                );
                              }),
                            ),
                            SizedBox(
                                height:
                                    8), // Espacement entre les étoiles et le bouton de popularité
                            // Afficher la popularité avec un texte en dessous
                            Container(
                              width: 80,
                              padding: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${conseil['popularity'] ?? 0} / 5',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );






        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
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
