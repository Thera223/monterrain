// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// Widget _buildDashboardContent() {
//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       children: [
//         // Statistiques des demandes
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildStatCard(
//                 'Demandes en attente', '20', Icons.pending, Colors.orange),
//             _buildStatCard('Demandes en cours', '15', Icons.work, Colors.blue),
//             _buildStatCard(
//                 'Demandes terminées', '50', Icons.check_circle, Colors.green),
//           ],
//         ),
//         SizedBox(height: 20),
//         Expanded(
//           child: SfCartesianChart(
//             primaryXAxis: CategoryAxis(),
//             title: ChartTitle(text: 'Performances du personnel'),
//             legend: Legend(isVisible: true),
//             series: <BarSeries>[
//               BarSeries<ChartData, String>(
//                 dataSource: _getPersonnelPerformanceData(),
//                 xValueMapper: (ChartData data, _) => data.personnel,
//                 yValueMapper: (ChartData data, _) => data.demandesTraitees,
//                 name: 'Demandes traitées',
//                 color: Colors.blue,
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Fonction pour créer une carte statistique
// Widget _buildStatCard(String title, String count, IconData icon, Color color) {
//   return Card(
//     elevation: 5,
//     child: Container(
//       width: 120, // Largeur de chaque carte
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 40,
//             color: color,
//           ),
//           SizedBox(height: 10),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 10),
//           Text(
//             count,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// // Exemple de données de performance du personnel
// List<ChartData> _getPersonnelPerformanceData() {
//   return [
//     ChartData('Personnel 1', 15),
//     ChartData('Personnel 2', 20),
//     ChartData('Personnel 3', 30),
//   ];
// }

// class ChartData {
//   final String personnel;
//   final int demandesTraitees;

//   ChartData(this.personnel, this.demandesTraitees);
// }


