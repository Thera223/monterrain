// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/services/serviceAuthentification/auth_service_mobile.dart';
// import 'package:terrain/services/user_service.dart';

// class RegisterPage extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nomController = TextEditingController();
//   final TextEditingController _prenomController = TextEditingController();
//   final TextEditingController _adresseController = TextEditingController();
//   bool _obscureTextRegister = true;

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthServiceMobile>(context);
//     final userService = Provider.of<UserService>(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextField(
//             controller: _nomController,
//             decoration: InputDecoration(
//               labelText: 'Nom',
//               prefixIcon: Icon(Icons.person_outline),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _prenomController,
//             decoration: InputDecoration(
//               labelText: 'Prénom',
//               prefixIcon: Icon(Icons.person_outline),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _adresseController,
//             decoration: InputDecoration(
//               labelText: 'Adresse',
//               prefixIcon: Icon(Icons.home_outlined),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(
//               labelText: 'Email',
//               prefixIcon: Icon(Icons.email_outlined),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _passwordController,
//             decoration: InputDecoration(
//               labelText: 'Mot de passe',
//               prefixIcon: Icon(Icons.lock_outline),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscureTextRegister
//                       ? Icons.visibility_off
//                       : Icons.visibility,
//                 ),
//                 onPressed: () {
//                   _obscureTextRegister = !_obscureTextRegister;
//                 },
//               ),
//             ),
//             obscureText: _obscureTextRegister,
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor:couleurprincipale,
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             onPressed: () async {
//               final user = await authService.registerWithEmail(
//                 _emailController.text,
//                 _passwordController.text,
//                 context,
//               );
//               if (user != null) {
//                 await userService.addDemandeur(
//                   email: _emailController.text,
//                   nom: _nomController.text,
//                   prenom: _prenomController.text,
//                   adresse: _adresseController.text,
//                   password: _passwordController
//                 );
//                 _showSuccessDialog(context);
//               }
//             },
//             child: Text(
//               'Inscrivez-vous',
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Fonction pour afficher un message de succès
//   void _showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Inscription réussie'),
//         content: Text('Votre compte a été créé avec succès.'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               DefaultTabController.of(ctx)?.animateTo(0);
//             },
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
