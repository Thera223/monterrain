import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Pour accéder à l'utilisateur connecté
import 'package:provider/provider.dart';
import 'package:terrain/pages/chefpersonnel/chef_user_page.dart'; // Gestion des utilisateurs (personnels)
import 'package:terrain/pages/chefpersonnel/demandechef.dart';
import 'package:terrain/services/demande_ser.dart'; // Service de gestion des demandes
import 'package:syncfusion_flutter_charts/charts.dart';

class ChefDashboardPage extends StatefulWidget {
  final String localite; // La localité du Chef

  ChefDashboardPage({required this.localite});

  @override
  _ChefDashboardPageState createState() => _ChefDashboardPageState();
}

class _ChefDashboardPageState extends State<ChefDashboardPage> {
  int _selectedIndex = 0; // Index de l'onglet sélectionné
  String? chefId;

  @override
  void initState() {
    super.initState();
    _loadChefId(); // Charge l'ID du chef dès l'initialisation
  }

  // Fonction pour récupérer l'ID du chef de personnel connecté
  Future<void> _loadChefId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        chefId = currentUser.uid; // Récupère l'UID du chef connecté
      });
    }
  }

  // Fonction pour gérer la navigation du drawer
  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Ferme le drawer après sélection
  }

  // Affichage du contenu selon l'onglet sélectionné
  Widget _buildPageContent() {
    if (chefId == null) {
      return Center(child: CircularProgressIndicator());
    }

    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return ChefPersonnelDemandesPage(); // Page des demandes
      case 2:
        return PersonnelManagementPage(); // Gestion des personnels ajoutés par le chef
      default:
        return _buildDashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord du Chef de Personnel'),
      ),
      drawer: _buildDrawer(), // Ajout du Drawer pour la navigation
      body: _buildPageContent(), // Affiche la page selon l'onglet sélectionné
    );
  }

  // Construction du Drawer pour la navigation
  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Chef de Personnel',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Tableau de bord'),
            onTap: () {
              _onDrawerItemTapped(0); // Sélection du tableau de bord
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Demandes'),
            onTap: () {
              _onDrawerItemTapped(1); // Sélection des demandes
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Utilisateurs'),
            onTap: () {
              _onDrawerItemTapped(
                  2); // Sélection de la gestion des utilisateurs
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(
                  context, '/'); // Redirection vers la page de connexion
            },
          ),
        ],
      ),
    );
  }

  // Tableau de bord principal du chef
  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                  'Demandes en attente', '20', Icons.pending, Colors.orange),
              _buildStatCard(
                  'Demandes en cours', '15', Icons.work, Colors.blue),
              _buildStatCard(
                  'Demandes terminées', '50', Icons.check_circle, Colors.green),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Performances du personnel'),
              legend: Legend(isVisible: true),
              series: <BarSeries>[
                BarSeries<ChartData, String>(
                  dataSource: _getPersonnelPerformanceData(),
                  xValueMapper: (ChartData data, _) => data.personnel,
                  yValueMapper: (ChartData data, _) => data.demandesTraitees,
                  name: 'Demandes traitées',
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Statistique pour les cartes
  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18)),
            Text(count,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Exemple de données de performance du personnel
  List<ChartData> _getPersonnelPerformanceData() {
    return [
      ChartData('Personnel 1', 15),
      ChartData('Personnel 2', 20),
      ChartData('Personnel 3', 30),
    ];
  }

  // // Liste des demandes
  // Widget _buildDemandesList() {
  //   return FutureBuilder(
  //     future: Provider.of<DemandeService>(context, listen: false)
  //         .getDemandesByLocalite(widget.localite),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Center(child: Text('Erreur : ${snapshot.error}'));
  //       } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
  //         return Center(child: Text('Aucune demande trouvée.'));
  //       } else {
  //         final demandes = snapshot.data as List;
  //         return ListView.builder(
  //           itemCount: demandes.length,
  //           itemBuilder: (context, index) {
  //             final demande = demandes[index];
  //             return ListTile(
  //               title: Text(demande['description']),
  //               subtitle: Text('Statut : ${demande['statut']}'),
  //               trailing: ElevatedButton(
  //                 child: Text('Assigner'),
  //                 onPressed: () {
  //                   _showAssignDialog(context, demande['id']);
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  // Boîte de dialogue pour assigner une demande
  void _showAssignDialog(BuildContext context, String demandeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedPersonnel = '';
        final personnelList = [
          'Personnel 1',
          'Personnel 2',
          'Personnel 3'
        ]; // Exemple de personnel. Ce sera récupéré dynamiquement dans la vraie application.

        return AlertDialog(
          title: Text('Assigner la demande'),
          content: DropdownButton<String>(
            value: selectedPersonnel,
            items: personnelList.map((String personnel) {
              return DropdownMenuItem<String>(
                value: personnel,
                child: Text(personnel),
              );
            }).toList(),
            onChanged: (value) {
              selectedPersonnel = value!;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Assigner'),
              onPressed: () {
                // Logique pour assigner la demande à un personnel
                Provider.of<DemandeService>(context, listen: false)
                    .assignDemande(demandeId, selectedPersonnel);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Exemple de données de performance du personnel
class ChartData {
  final String personnel;
  final int demandesTraitees;

  ChartData(this.personnel, this.demandesTraitees);
}
