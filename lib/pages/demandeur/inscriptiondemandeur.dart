// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/services/serviceAuthentification/auth_service_mobile.dart';
// import 'package:terrain/services/user_service.dart';

// class RegisterPage extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nomController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthServiceMobile>(context);
//     final userService = Provider.of<UserService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             // Logo
//             Image.asset(
//               'assets/images/logo.png', // Remplacez par votre logo
//               height: 120,
//             ),
//             SizedBox(height: 20),
//             // Titre Inscription
//             Text(
//               'Inscription',
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.purple,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _nomController,
//               decoration: InputDecoration(
//                 labelText: 'Nom',
//                 prefixIcon: Icon(Icons.person_outline),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email_outlined),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Mot de passe',
//                 prefixIcon: Icon(Icons.lock_outline),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.visibility_off),
//                   onPressed: () {
//                     // Action pour masquer/afficher le mot de passe
//                   },
//                 ),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.purple, // Couleur du bouton
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () async {
//                 final user = await authService.registerWithEmail(
//                   _emailController.text,
//                   _passwordController.text,
//                   context,
//                 );
//                 if (user != null) {
//                   await userService.addDemandeur(
//                     email: _emailController.text,
                   
//                     nom: _nomController.text,
//                     prenom: '', // Ajouter le prénom si nécessaire
//                     adresse: '', // Ajouter l'adresse si nécessaire
//                     password: _passwordController.text, 
//                   );
                  
//                   Navigator.pop(context); // Retour après inscription
//                 }
//               },
//               child: Text(
//                 'inscrivez-vous',
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
