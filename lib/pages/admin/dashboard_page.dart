


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Ajout du provider pour les services
// import 'package:syncfusion_flutter_charts/charts.dart'; // Si tu utilises des graphiques
// import 'package:terrain/pages/admin/admin_users_page.dart';
// import 'package:terrain/pages/admin/admindemande.dart';
// import 'package:terrain/pages/admin/assistants_page.dart';
// import 'package:terrain/pages/admin/parcelles_page.dart';
// import 'package:terrain/pages/config_charte_coul.dart';
// import 'package:terrain/pages/historique.dart';
// import 'package:terrain/services/demande_ser.dart';
// import 'package:terrain/services/parcelle_service.dart';
// import 'package:terrain/services/user_service.dart';
// import '../sidebar.dart'; // Réintégration de la CustomNavigationSidebar

// class DashboardPage extends StatefulWidget {
//   final String role;

//   DashboardPage({required this.role});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   int _selectedIndex = 0;
//   bool isLoading = true;
//   int totalUsers = 0;
//   int totalResponses = 0;
//   int totalRequests = 0;
//   int totalParcelles = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   Future<void> _loadDashboardData() async {
//     final demandeService = Provider.of<DemandeService>(context, listen: false);
//     final userService = Provider.of<UserService>(context, listen: false);
//     final parcelleService =
//         Provider.of<ParcelleService>(context, listen: false);

//     try {
//       totalUsers = await userService.getUsersCount();
//       totalResponses = await demandeService.getTotalResponses();
//       totalRequests = await demandeService.getTotalRequests();
//       totalParcelles = await parcelleService.getParcellesCount();

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Erreur lors du chargement des données du tableau de bord: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
      
//       drawer: CustomNavigationSidebar(
        
//         selectedIndex: _selectedIndex,
//         onItemTapped: (index) {
//           setState(() {
//             _selectedIndex = index; // Mise à jour de l'index sélectionné
//           });
//         },
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           widget.role == 'admin'
//               ? 'Admin Dashboard'
//               : 'Chef Personnel Dashboard',
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
//           IconButton(
//               icon: Icon(Icons.notifications, color: Colors.black),
//               onPressed: () {}),
//           CircleAvatar(
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, color: Colors.white)),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _buildPageContent(), // Appel à la fonction de gestion des pages
//     );
//   }

//   // Gestion du contenu de la page en fonction de l'index sélectionné
//   Widget _buildPageContent() {
//     switch (_selectedIndex) {
//       case 0:
//         return _buildDashboardContent(); // Retourne le tableau de bord principal
//       case 1:
//         return widget.role == 'admin'
//             ? UsersPage()
//             : Text("Page inaccessible"); // Page des utilisateurs pour l'admin
//       case 2:
//         return AdminDemandesPage(); // Page des demandes
//       case 3:
//         return AssistantsPage(); // Page des assistants juridiques
//       case 4:
//         return LogsPage(); // Page des logs historiques
//       case 5:
//         return ParcelleListPage(); // Page des parcelles
//       default:
//         return _buildDashboardContent(); // Page par défaut, le dashboard principal
//     }
//   }

//   // Construction du tableau de bord principal
//   Widget _buildDashboardContent() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildDashboardHeader(),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStatCard('Utilisateurs', totalUsers.toString(),
//                     Icons.person, Colors.green),
//                 _buildStatCard('Réponses', totalResponses.toString(),
//                     Icons.mail, Colors.blue),
//                 _buildStatCard('Demandes', totalRequests.toString(),
//                     Icons.request_page, Colors.red),
//                 _buildStatCard('Parcelles', totalParcelles.toString(),
//                     Icons.landscape, Colors.orange),
//               ],
//             ),
//             SizedBox(height: 20),
//             _buildGraphSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   // En-tête avec les boutons de filtre et d'exportation
//   Widget _buildDashboardHeader() {
//     return Row(
//       children: [
//         Text('Dashboard',
//             style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87)),
//         Spacer(),
//        ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.filter_list, color: Colors.white), // Icône en blanc
//           label: Text('Filtrer',
//               style: TextStyle(color: Colors.white)), // Texte en blanc
//           style: ElevatedButton.styleFrom(
//             backgroundColor: couleurprincipale, // Couleur de fond personnalisée
//             foregroundColor: Colors.white, // Couleur du texte et des icônes
//           ),
//         ),
//         SizedBox(width: 8),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.download, color: Colors.white), // Icône en blanc
//           label: Text('Exporter',
//               style: TextStyle(color: Colors.white)), // Texte en blanc
//           style: ElevatedButton.styleFrom(
//             backgroundColor: couleurprincipale, // Couleur de fond personnalisée
//             foregroundColor: Colors.white, // Couleur du texte et des icônes
//           ),
//         ),

//       ],
//     );
//   }

//   // Cartes pour les statistiques
//   Widget _buildStatCard(
//       String title, String count, IconData icon, Color color) {
//     return Expanded(
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(icon, color: color, size: 30),
//                   Spacer(),
//                   Text(count,
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Section graphique avec Syncfusion
//   Widget _buildGraphSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: Offset(0, 5))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Statistique des demandes et réponses',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 20),
//           _buildGraph(), // Graphique de statistiques
//         ],
//       ),
//     );
//   }

//   // Graphique simple
//   Widget _buildGraph() {
//     return SfCartesianChart(
//       primaryXAxis: CategoryAxis(),
//       title: ChartTitle(text: 'Demandes et Réponses'),
//       legend: Legend(isVisible: true),
//       series: <LineSeries>[
//         LineSeries<ChartData, String>(
//           dataSource: _getChartData(),
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.y,
//           name: 'Demandes',
//         ),
//         LineSeries<ChartData, String>(
//           dataSource: _getChartData(),
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.y2,
//           name: 'Réponses',
//         ),
//       ],
//     );
//   }

//   List<ChartData> _getChartData() {
//     return [
//       ChartData('Jan', 150, 100),
//       ChartData('Fév', 180, 120),
//       ChartData('Mar', 200, 140),
//       ChartData('Avr', 220, 160),
//     ];
//   }
// }

// class ChartData {
//   final String x;
//   final double y;
//   final double y2;

//   ChartData(this.x, this.y, this.y2);
// }


//100000


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:terrain/services/demande_ser.dart';
// import 'package:terrain/services/parcelle_service.dart';
// import 'package:terrain/services/user_service.dart';
// import '../sidebar.dart';
// import 'package:intl/intl.dart'; // Import pour DateFormat

// class DashboardPage extends StatefulWidget {
//   final String role;

//   DashboardPage({required this.role});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   int _selectedIndex = 0;
//   bool isLoading = true;
//   int totalUsers = 0;
//   int totalResponses = 0;
//   int totalRequests = 0;
//   int totalParcelles = 0;

//   List<ChartData> chartData = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   Future<void> _loadDashboardData() async {
//     final demandeService = Provider.of<DemandeService>(context, listen: false);
//     final userService = Provider.of<UserService>(context, listen: false);
//     final parcelleService =
//         Provider.of<ParcelleService>(context, listen: false);

//     try {
//       // Chargement des valeurs
//       totalUsers = await userService.getUsersCount();
//       totalResponses = await demandeService.getTotalResponses();
//       totalRequests = await demandeService.getTotalRequests();
//       totalParcelles = await parcelleService.getParcellesCount();

//       // Charger les données pour le graphique
//       await _loadChartData();

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Erreur lors du chargement des données du tableau de bord: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadChartData() async {
//     final demandeService = Provider.of<DemandeService>(context, listen: false);
//     final requestData = await demandeService.getDemandesGroupedByDate();
//     final responseData = await demandeService.getResponsesGroupedByDate();

//     chartData = [];

//     requestData.forEach((date, count) {
//       final responseCount = responseData[date] ?? 0;
//       chartData.add(ChartData(_normalizeDate(date), count, responseCount));
//     });

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: CustomNavigationSidebar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           widget.role == 'admin'
//               ? 'Admin Dashboard'
//               : 'Chef Personnel Dashboard',
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
//           IconButton(
//               icon: Icon(Icons.notifications, color: Colors.black),
//               onPressed: () {}),
//           CircleAvatar(
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, color: Colors.white)),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     _buildDashboardHeader(),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildStatCard('Utilisateurs', totalUsers.toString(),
//                             Icons.person, Colors.green),
//                         _buildStatCard('Réponses', totalResponses.toString(),
//                             Icons.mail, Colors.blue),
//                         _buildStatCard('Demandes', totalRequests.toString(),
//                             Icons.request_page, Colors.red),
//                         _buildStatCard('Parcelles', totalParcelles.toString(),
//                             Icons.landscape, Colors.orange),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     _buildGraphSection(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildDashboardHeader() {
//     return Row(
//       children: [
//         Text('Dashboard',
//             style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87)),
//         Spacer(),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.filter_list, color: Colors.white),
//           label: Text('Filtrer', style: TextStyle(color: Colors.white)),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//         ),
//         SizedBox(width: 8),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.download, color: Colors.white),
//           label: Text('Exporter', style: TextStyle(color: Colors.white)),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//       String title, String count, IconData icon, Color color) {
//     return Expanded(
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(icon, color: color, size: 30),
//                   Spacer(),
//                   Text(count,
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   DateTime _normalizeDate(String dateStr) {
//     // Normalise les dates pour s'assurer qu'elles suivent le format "yyyy-MM-dd"
//     List<String> parts = dateStr.split('-');
//     if (parts[1].length == 1) parts[1] = '0${parts[1]}';
//     if (parts[2].length == 1) parts[2] = '0${parts[2]}';
//     return DateTime.parse(parts.join('-'));
//   }

//   Widget _buildGraphSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: Offset(0, 5))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Statistique des demandes et réponses par date',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           _buildGraph(),
//         ],
//       ),
//     );
//   }

//   Widget _buildGraph() {
//     return SfCartesianChart(
//       primaryXAxis: DateTimeAxis(
//         intervalType: DateTimeIntervalType.months,
//         interval: 1,
//         dateFormat: DateFormat.MMM(), // Format d'affichage des mois
//         title: AxisTitle(text: 'Date'),
//         rangePadding: ChartRangePadding.round,
//       ),
//       title: ChartTitle(text: 'Tendance des Demandes et Réponses'),
//       legend: Legend(isVisible: true),
//       tooltipBehavior: TooltipBehavior(enable: true),
//       zoomPanBehavior: ZoomPanBehavior(
//         enablePinching: true,
//         enablePanning: true,
//         zoomMode: ZoomMode.x,
//       ),
//       series: <CartesianSeries>[
//         SplineSeries<ChartData, DateTime>(
//           dataSource: chartData,
//           xValueMapper: (ChartData data, _) => data.date,
//           yValueMapper: (ChartData data, _) => data.demandes,
//           name: 'Demandes',
//           color: Colors.blue,
//           markerSettings: MarkerSettings(isVisible: true),
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//         ),
//         SplineSeries<ChartData, DateTime>(
//           dataSource: chartData,
//           xValueMapper: (ChartData data, _) => data.date,
//           yValueMapper: (ChartData data, _) => data.reponses,
//           name: 'Réponses',
//           color: Colors.green,
//           markerSettings: MarkerSettings(isVisible: true),
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//         ),
//       ],
//     );
//   }
// }

// class ChartData {
//   final DateTime date;
//   final int demandes;
//   final int reponses;

//   ChartData(this.date, this.demandes, this.reponses);
// }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/pages/admin/admin_users_page.dart';
// import 'package:terrain/pages/admin/admindemande.dart';
// import 'package:terrain/pages/admin/assistants_page.dart';
// import 'package:terrain/pages/admin/parcelles_page.dart';
// import 'package:terrain/pages/config_charte_coul.dart';
// import 'package:terrain/pages/historique.dart';
// import 'package:terrain/services/demande_ser.dart';
// import 'package:terrain/services/parcelle_service.dart';
// import 'package:terrain/services/user_service.dart';
// import '../sidebar.dart';

// class DashboardPage extends StatefulWidget {
//   final String role;

//   DashboardPage({required this.role});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   int _selectedIndex = 0;
//   bool isLoading = true;
//   int totalUsers = 0;
//   int totalResponses = 0;
//   int totalRequests = 0;
//   int totalParcelles = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   Future<void> _loadDashboardData() async {
//     final demandeService = Provider.of<DemandeService>(context, listen: false);
//     final userService = Provider.of<UserService>(context, listen: false);
//     final parcelleService =
//         Provider.of<ParcelleService>(context, listen: false);

//     try {
//       totalUsers = await userService.getUsersCount();
//       totalResponses = await demandeService.getTotalResponses();
//       totalRequests = await demandeService.getTotalRequests();
//       totalParcelles = await parcelleService.getParcellesCount();

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Erreur lors du chargement des données du tableau de bord: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: CustomNavigationSidebar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           widget.role == 'admin'
//               ? 'Admin Dashboard'
//               : 'Chef Personnel Dashboard',
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
//           IconButton(
//               icon: Icon(Icons.notifications, color: Colors.black),
//               onPressed: () {}),
//           CircleAvatar(
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, color: Colors.white)),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _buildPageContent(),
//     );
//   }

//   Widget _buildPageContent() {
//     switch (_selectedIndex) {
//       case 0:
//         return _buildDashboardContent();
//       case 1:
//         return widget.role == 'admin' ? UsersPage() : Text("Page inaccessible");
//       case 2:
//         return AdminDemandesPage();
//       case 3:
//         return AssistantsPage();
//       case 4:
//         return LogsPage();
//       case 5:
//         return ParcelleListPage();
//       default:
//         return _buildDashboardContent();
//     }
//   }

//   Widget _buildDashboardContent() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildDashboardHeader(),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStatCard('Utilisateurs', totalUsers.toString(),
//                     Icons.person, Colors.green),
//                 _buildStatCard('Réponses', totalResponses.toString(),
//                     Icons.mail, Colors.blue),
//                 _buildStatCard('Demandes', totalRequests.toString(),
//                     Icons.request_page, Colors.red),
//                 _buildStatCard('Parcelles', totalParcelles.toString(),
//                     Icons.landscape, Colors.orange),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDashboardHeader() {
//     return Row(
//       children: [
//         Text('Dashboard',
//             style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87)),
//         Spacer(),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.filter_list, color: Colors.white),
//           label: Text('Filtrer', style: TextStyle(color: Colors.white)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: couleurprincipale,
//             foregroundColor: Colors.white,
//           ),
//         ),
//         SizedBox(width: 8),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.download, color: Colors.white),
//           label: Text('Exporter', style: TextStyle(color: Colors.white)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: couleurprincipale,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//       String title, String count, IconData icon, Color color) {
//     return Expanded(
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(icon, color: color, size: 30),
//                   Spacer(),
//                   Text(count,
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/admin/admin_users_page.dart';
import 'package:terrain/pages/admin/admindemande.dart';
import 'package:terrain/pages/admin/assistants_page.dart';
import 'package:terrain/pages/admin/parcelles_page.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/pages/historique.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/services/parcelle_service.dart';
import 'package:terrain/services/user_service.dart';
import '../sidebar.dart';

class DashboardPage extends StatefulWidget {
  final String role;

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
  int totalParcelles = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final demandeService = Provider.of<DemandeService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final parcelleService =
        Provider.of<ParcelleService>(context, listen: false);

    try {
      totalUsers = await userService.getUsersCount();
      totalResponses = await demandeService.getTotalResponses();
      totalRequests = await demandeService.getTotalRequests();
      totalParcelles = await parcelleService.getParcellesCount();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavigationSidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.role == 'admin'
              ? 'Admin Dashboard'
              : 'Chef Personnel Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {}),
          CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white)),
          SizedBox(width: 16),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return widget.role == 'admin' ? UsersPage() : Text("Page inaccessible");
      case 2:
        return AdminDemandesPage();
      case 3:
        return AssistantsPage();
      case 4:
        return LogsPage();
      case 5:
        return ParcelleListPage();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDashboardHeader(),
            SizedBox(height: 20),
            _buildStatCardsWrap(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return Row(
      children: [
        Text('Dashboard',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        Spacer(),

      ],
    );
  }

// Nouvelle méthode pour afficher les cartes statistiques en une seule ligne en utilisant Wrap
Widget _buildStatCardsWrap() {
  return Wrap(
    spacing: 6, // Espacement horizontal entre les cartes
    runSpacing: 6, // Espacement vertical entre les cartes
    children: [
      _buildStatCard('Utilisateurs', totalUsers.toString(), Icons.person, Colors.green, Colors.green[100]!),
      _buildStatCard('Réponses', totalResponses.toString(), Icons.mail, Colors.blue, Colors.blue[100]!),
      _buildStatCard('Demandes', totalRequests.toString(), Icons.request_page, Colors.red, Colors.red[100]!),
      _buildStatCard('Parcelles', totalParcelles.toString(), Icons.landscape, Colors.orange, Colors.orange[100]!),
    ],
  );
}

Widget _buildStatCard(String title, String count, IconData icon, Color iconColor, Color backgroundColor) {
  return SizedBox(
    width: 300, // Largeur fixe pour chaque carte
    height: 300, // Hauteur fixe pour chaque carte
    child: Card(
      color: backgroundColor, // Couleur de fond de la carte
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4), // Espacement interne minimal
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 40), // Icône avec couleur spécifique
            SizedBox(height: 2), // Espacement minimal entre icône et texte
            Text(count, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: iconColor)), // Texte du nombre
            Text(title, style: TextStyle(fontSize: 28, color: Colors.grey[700])), // Texte du titre
          ],
        ),
      ),
    ),
  );
}
}