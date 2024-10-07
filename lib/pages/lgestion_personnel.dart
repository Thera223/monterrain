// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/services/user_service.dart';

// class PersonnelPage extends StatelessWidget {
//   final String localite; // La localité du chef de personnel

//   PersonnelPage({required this.localite});

//   @override
//   Widget build(BuildContext context) {
//     final userService = Provider.of<UserService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion du Personnel - $localite'),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: userService.getPersonnelByLocalite(localite),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Aucun personnel trouvé.'));
//           }

//           final personnelList = snapshot.data!;
//           return ListView.builder(
//             itemCount: personnelList.length,
//             itemBuilder: (context, index) {
//               final personnel = personnelList[index];
//               return ListTile(
//                 title: Text('${personnel['nom']} ${personnel['prenom']}'),
//                 subtitle: Text('Email: ${personnel['email']}'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     await userService.deleteUser(personnel['id']);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddPersonnelDialog(context, userService);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   // Boîte de dialogue pour ajouter un membre du personnel
//   void _showAddPersonnelDialog(BuildContext context, UserService userService) {
//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController nomController = TextEditingController();
//     final TextEditingController prenomController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Ajouter un membre du personnel'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nomController,
//               decoration: InputDecoration(labelText: 'Nom'),
//             ),
//             TextField(
//               controller: prenomController,
//               decoration: InputDecoration(labelText: 'Prénom'),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Mot de passe'),
//               obscureText: true,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await userService.addUser(
//                 email: emailController.text,
//                 password: passwordController.text,
//                 role: 'personnel',
//                 nom: nomController.text,
//                 prenom: prenomController.text,
//                 adresse: '', // L'adresse n'est pas essentielle ici
//                 localite:
//                     localite, chefId: '', // L'utilisateur est lié à la localité du chef
//               );
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Ajouter'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Annuler'),
//           ),
//         ],
//       ),
//     );
//   }
// }
