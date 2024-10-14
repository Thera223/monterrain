// import 'package:flutter/material.dart';
// import 'package:terrain/pages/admin/admindemande.dart';
// import 'package:terrain/pages/demandeur/dmobdemande.dart';
// import 'package:terrain/pages/admin/admin_users_page.dart';
// import 'package:terrain/pages/historique.dart';
// import '../sidebar.dart'; // Importation du sidebar renommé
// import 'parcelles_page.dart'; // Import de la page parcelle
// import 'assistants_page.dart'; // Import de la page assistant
// import 'package:syncfusion_flutter_charts/charts.dart'; // Pour le graphique des statistiques

// class DashboardPage extends StatefulWidget {
//   final String role; // Ajout du rôle pour la redirection des vues spécifiques
//   DashboardPage({required this.role});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   int _selectedIndex = 0;

//   // Gestion de la navigation par index
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     Navigator.pop(context); // Fermer le drawer après la sélection
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: CustomNavigationSidebar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//       appBar: AppBar(
//         title: Text(widget.role == 'admin'
//             ? 'Admin Dashboard'
//             : 'Chef Personnel Dashboard'),
//       ),
//       body: _buildPageContent(),
//     );
//   }

//   // Affichage de la page en fonction de l'utilisateur (Admin vs Chef Personnel)
//   Widget _buildPageContent() {
//     switch (_selectedIndex) {
//       case 0:
//         return _buildDashboardContent(); // Tableau de bord principal
//       case 1:
//         if (widget.role == 'admin') {
//           return UsersPage(); // Admin peut voir tous les utilisateurs
//         } else {
//           return Text(
//               "Page inaccessible"); // Chef ne peut pas accéder à cette page
//         }
//       case 2:
//         return AdminDemandesPage(); // Affiche la page Demandes
//       case 3:
//         return AssistantsPage(); // Affiche la page Assistants Juridiques
//       case 4:
//         return LogsPage(); // Affiche la page Parcelles
//       case 5:
//         return ParcelleListPage(); // Affiche la liste des parcelles
//       default:
//         return _buildDashboardContent(); // Par défaut, affiche le tableau de bord
//     }
//   }

//   // Contenu du dashboard principal
//   Widget _buildDashboardContent() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildStatCard(
//                   'Utilisateurs', '1500', Icons.person, Colors.green),
//               _buildStatCard('Réponses', '320', Icons.mail, Colors.blue),
//               _buildStatCard('Demandes', '450', Icons.request_page, Colors.red),
//             ],
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: SfCartesianChart(
//               primaryXAxis: CategoryAxis(),
//               title: ChartTitle(text: 'Statistique des demandes et réponses'),
//               legend: Legend(isVisible: true),
//               series: <LineSeries>[
//                 LineSeries<ChartData, String>(
//                   dataSource: _getChartData(),
//                   xValueMapper: (ChartData data, _) => data.x,
//                   yValueMapper: (ChartData data, _) => data.y,
//                   name: 'Demandes',
//                 ),
//                 LineSeries<ChartData, String>(
//                   dataSource: _getChartData(),
//                   xValueMapper: (ChartData data, _) => data.x,
//                   yValueMapper: (ChartData data, _) => data.y2,
//                   name: 'Réponses',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(
//       String title, String count, IconData icon, Color color) {
//     return Card(
//       color: Colors.white,
//       elevation: 5,
//       child: Container(
//         width: 150,
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(icon, size: 40, color: color),
//             SizedBox(height: 10),
//             Text(title, style: TextStyle(fontSize: 18)),
//             Text(count,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   List<ChartData> _getChartData() {
//     return [
//       ChartData('Jour 1', 150, 100),
//       ChartData('Jour 2', 180, 110),
//       ChartData('Jour 3', 200, 130),
//       ChartData('Jour 4', 220, 140),
//       ChartData('Jour 5', 250, 160),
//     ];
//   }
// }

// class ChartData {
//   final String x;
//   final double y;
//   final double y2;

//   ChartData(this.x, this.y, this.y2);
// }










import 'package:flutter/material.dart';
import 'package:terrain/pages/admin/admindemande.dart';
import 'package:terrain/pages/admin/admin_users_page.dart';
import 'package:terrain/pages/historique.dart';
import 'package:terrain/services/demande_ser.dart';
// Import du service de demandes
import 'package:terrain/services/user_service.dart'; // Import du service d'utilisateurs
import 'package:provider/provider.dart'; // Pour la gestion d'état avec Provider
import 'package:syncfusion_flutter_charts/charts.dart'; // Pour les graphiques

import '../sidebar.dart'; // Importation du sidebar
import 'parcelles_page.dart'; // Import de la page parcelle
import 'assistants_page.dart'; // Import de la page assistant

class DashboardPage extends StatefulWidget {
  final String role; // Rôle de l'utilisateur connecté

  DashboardPage({required this.role});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool isLoading = true;

  int totalUsers = 0;
  int totalResponses = 0;
  int totalRequests = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Fonction pour charger les données réelles de Firestore
  Future<void> _loadDashboardData() async {
    final demandeService = Provider.of<DemandeService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);

    try {
      // Charger les données depuis Firestore
      totalUsers = await userService.getUsersCount();
      totalResponses = await demandeService.getTotalResponses();
      totalRequests = await demandeService.getTotalRequests();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données du tableau de bord: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Gestion de la navigation par index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Fermer le drawer après la sélection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavigationSidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text(widget.role == 'admin'
            ? 'Admin Dashboard'
            : 'Chef Personnel Dashboard'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Afficher un loader pendant le chargement
          : _buildPageContent(),
    );
  }

  // Affichage de la page en fonction de l'utilisateur (Admin vs Chef Personnel)
  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent(); // Tableau de bord principal
      case 1:
        if (widget.role == 'admin') {
          return UsersPage(); // Admin peut voir tous les utilisateurs
        } else {
          return Text(
              "Page inaccessible"); // Chef ne peut pas accéder à cette page
        }
      case 2:
        return AdminDemandesPage(); // Affiche la page Demandes
      case 3:
        return AssistantsPage(); // Affiche la page Assistants Juridiques
      case 4:
        return LogsPage(); // Affiche la page Logs
      case 5:
        return ParcelleListPage(); // Affiche la liste des parcelles
      default:
        return _buildDashboardContent(); // Par défaut, affiche le tableau de bord
    }
  }

  // Contenu du dashboard principal
  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                  'Utilisateurs', '$totalUsers', Icons.person, Colors.green),
              _buildStatCard(
                  'Réponses', '$totalResponses', Icons.mail, Colors.blue),
              _buildStatCard(
                  'Demandes', '$totalRequests', Icons.request_page, Colors.red),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Statistique des demandes et réponses'),
              legend: Legend(isVisible: true),
              series: <LineSeries>[
                LineSeries<ChartData, String>(
                  dataSource: _getChartData(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Demandes',
                ),
                LineSeries<ChartData, String>(
                  dataSource: _getChartData(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  name: 'Réponses',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  // Exemple de données pour le graphique
  List<ChartData> _getChartData() {
    return [
      ChartData('Jour 1', 150, 100),
      ChartData('Jour 2', 180, 110),
      ChartData('Jour 3', 200, 130),
      ChartData('Jour 4', 220, 140),
      ChartData('Jour 5', 250, 160),
    ];
  }
}

class ChartData {
  final String x;
  final double y;
  final double y2;

  ChartData(this.x, this.y, this.y2);
}


