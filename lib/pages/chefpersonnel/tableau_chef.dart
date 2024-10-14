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

//10000000000



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:terrain/pages/chefpersonnel/chef_user_page.dart';
// import 'package:terrain/pages/chefpersonnel/demandechef.dart';
// import 'package:terrain/services/dashservice.dart'; // Service pour récupérer les données du tableau de bord
// // Exemple pour une autre page

// class ChefDashboardPage extends StatefulWidget {
//   final String localite;

//   ChefDashboardPage({required this.localite});

//   @override
//   _ChefDashboardPageState createState() => _ChefDashboardPageState();
// }

// class _ChefDashboardPageState extends State<ChefDashboardPage> {
//   int totalPersonnel = 0;
//   int totalDemandeurs = 0;
//   int totalDemandesRecues = 0;
//   int totalDemandesAssignees = 0;
//   int totalDemandesEnAttente = 0;
//   int totalDemandesEnCours = 0;
//   int totalDemandesRepondues = 0;
//   List<PersonnelPerfData> personnelPerformance = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   Future<void> _loadDashboardData() async {
//     final dashboardService =
//         Provider.of<DashboardService>(context, listen: false);

//     try {
//       totalPersonnel =
//           await dashboardService.getTotalPersonnelByLocalite(widget.localite);
//       totalDemandeurs =
//           await dashboardService.getTotalDemandeursByLocalite(widget.localite);
//       totalDemandesRecues =
//           await dashboardService.getTotalDemandesByLocalite(widget.localite);
//       totalDemandesAssignees =
//           await dashboardService.getTotalDemandesAssignees(widget.localite);
//       totalDemandesEnAttente = await dashboardService.getTotalDemandesByStatut(
//           'En attente', widget.localite);
//       totalDemandesEnCours = await dashboardService.getTotalDemandesByStatut(
//           'En cours', widget.localite);
//       totalDemandesRepondues = await dashboardService.getTotalDemandesByStatut(
//           'Répondu', widget.localite);

//       personnelPerformance = (await dashboardService
//               .getPersonnelPerformanceByLocalite(widget.localite))
//           .cast<PersonnelPerfData>();

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tableau de bord du Chef de Personnel'),
//       ),
//       drawer: _buildDrawer(), // Ajouter un Drawer pour la navigation
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Statistiques générales',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     _buildStatCards(),
//                     SizedBox(height: 20),
//                     Text('Comparaison des demandes',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     _buildComparisonChart(),
//                     SizedBox(height: 20),
//                     Text('Performances du personnel',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     _buildPersonnelPerformanceChart(),
//                     SizedBox(height: 20),
//                     Text('Top Personnel par performance',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     _buildTopPersonnelList(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   // Fonction pour construire le Drawer (sidebar)
//   Drawer _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.person, size: 50, color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(
//                   'Chef de Personnel',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 Text(
//                   FirebaseAuth.instance.currentUser?.email ?? '',
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.dashboard),
//             title: Text('Tableau de bord'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         ChefDashboardPage(localite: widget.localite)),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.list),
//             title: Text('Demandes'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         ChefPersonnelDemandesPage()), // Exemple d'une autre page
//               );
//             },
//           ),
//             ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Utilisateur'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         PersonnelManagementPage()), // Exemple d'une autre page
//               );
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Déconnexion'),
//             onTap: () {
//               FirebaseAuth.instance.signOut();
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCards() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildStatCard(
//             'Personnel total', '$totalPersonnel', Icons.group, Colors.blue),
//         _buildStatCard('Demandeurs total', '$totalDemandeurs', Icons.person,
//             Colors.orange),
//         _buildStatCard('Demandes reçues', '$totalDemandesRecues', Icons.inbox,
//             Colors.green),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//       String title, String count, IconData icon, Color color) {
//     return Card(
//       elevation: 5,
//       color: Colors.white,
//       child: Container(
//         width: 120,
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(icon, size: 40, color: color),
//             SizedBox(height: 10),
//             Text(title, style: TextStyle(fontSize: 16)),
//             SizedBox(height: 10),
//             Text(count,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildComparisonChart() {
//     return SfCartesianChart(
//       primaryXAxis: CategoryAxis(),
//       title: ChartTitle(text: 'Demandes reçues vs répondus'),
//       series: <CartesianSeries>[
//         BarSeries<DemandeChartData, String>(
//           dataSource: [
//             DemandeChartData('Reçues', totalDemandesRecues),
//             DemandeChartData('Répondues', totalDemandesRepondues),
//           ],
//           xValueMapper: (DemandeChartData data, _) => data.label,
//           yValueMapper: (DemandeChartData data, _) => data.value,
//           color: Colors.blue,
//         ),
//       ],
//     );
//   }

//   Widget _buildPersonnelPerformanceChart() {
//     return SfCartesianChart(
//       primaryXAxis: CategoryAxis(),
//       title: ChartTitle(text: 'Performances du personnel'),
//       series: <CartesianSeries>[
//         BarSeries<PersonnelPerfData, String>(
//           dataSource: personnelPerformance,
//           xValueMapper: (PersonnelPerfData data, _) => data.personnelName,
//           yValueMapper: (PersonnelPerfData data, _) => data.demandesTraitees,
//           color: Colors.orange,
//         ),
//       ],
//     );
//   }

//   Widget _buildTopPersonnelList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: personnelPerformance.length,
//       itemBuilder: (context, index) {
//         final personnel = personnelPerformance[index];
//         return ListTile(
//           leading: Icon(Icons.person),
//           title: Text(personnel.personnelName),
//           trailing: Text('${personnel.demandesTraitees} demandes traitées'),
//         );
//       },
//     );
//   }
// }

// // Modèle pour les données du graphique de comparaison
// class DemandeChartData {
//   final String label;
//   final int value;

//   DemandeChartData(this.label, this.value);
// }

// // Modèle pour les performances du personnel
// class PersonnelPerfData {
//   final String personnelName;
//   final int demandesTraitees;

//   PersonnelPerfData(this.personnelName, this.demandesTraitees);
// }

// // Exemple d'une autre page pour la navigation
// class OtherPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Autre page'),
//       ),
//       body: Center(
//         child: Text('Page des demandes ou autres.'),
//       ),
//     );
//   }
// }
