// import 'package:flutter/material.dart';

// class StatCard extends StatelessWidget {
//   final String title;
//   final String count;
//   final IconData icon;
//   final Color color;

//   StatCard(
//       {required this.title,
//       required this.count,
//       required this.icon,
//       required this.color});

//   @override
//   Widget build(BuildContext context) {
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
// }

import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  StatCard(
      {required this.title,
      required this.count,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
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
}
