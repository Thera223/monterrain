// import 'package:flutter/material.dart';
// import 'package:terrain/pages/demandeur/insc_dem_page.dart';
// import 'package:terrain/pages/demandeur/mobil_login_page.dart';


// class AuthPage extends StatefulWidget {
//   @override
//   _AuthPageState createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 20),
//               // Logo
//               Image.asset(
//                 'assets/images/logo.png',
//                 height: 120,
//               ),
//               SizedBox(height: 20),
//               // Onglets Connexion/Inscription
//               TabBar(
//                 controller: _tabController,
//                 labelColor:couleurprincipale,
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor:couleurprincipale,
//                 tabs: [
//                   Tab(text: 'Connexion'),
//                   Tab(text: 'Inscription'),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.6,
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // Connexion
//                     LoginPageMobile(),
//                     // Inscription
//                     RegisterPage(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
