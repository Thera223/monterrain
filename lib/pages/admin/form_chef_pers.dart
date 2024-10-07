// import 'package:flutter/material.dart';
// import 'package:terrain/model/chef_personnel.dart';
// import 'package:terrain/services/chef_personnel_service.dart';

// class AddChefPersonnelPage extends StatelessWidget {
//   final TextEditingController nomController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController telephoneController = TextEditingController();
//   final TextEditingController localiteController = TextEditingController();

//   final ChefPersonnelService chefPersonnelService = ChefPersonnelService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ajouter un Chef de Personnel'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             TextField(
//               controller: nomController,
//               decoration: InputDecoration(labelText: 'Nom'),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: telephoneController,
//               decoration: InputDecoration(labelText: 'Téléphone'),
//             ),
//             TextField(
//               controller: localiteController,
//               decoration: InputDecoration(labelText: 'Localité'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 ChefPersonnel newChef = ChefPersonnel(
//                   id: '',
//                   nom: nomController.text,
//                   email: emailController.text,
//                   telephone: telephoneController.text,
//                   poste: 'Chef de Personnel',
//                   localite: localiteController.text, // Localité ajoutée
//                   personnelIds: [],
//                 );
//                 chefPersonnelService.addChefPersonnel(newChef);
//                 Navigator.pop(context);
//               },
//               child: Text('Ajouter Chef'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
