// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:terrain/pages/chefpersonnel/detail_utilisateur.dart';
// import 'package:terrain/services/hist_service.dart';
// import 'package:terrain/services/user_service.dart';

// class PersonnelManagementPage extends StatefulWidget {
//   @override
//   _PersonnelManagementPageState createState() =>
//       _PersonnelManagementPageState();
// }

// class _PersonnelManagementPageState extends State<PersonnelManagementPage> {
//   String? chefId;

//   @override
//   void initState() {
//     super.initState();
//     _loadChefId();
//   }

//   Future<void> _loadChefId() async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(currentUser.uid)
//             .get();

//         if (userDoc.exists && userDoc['role'] == 'chef_personnel') {
//           setState(() {
//             chefId = currentUser.uid;
//           });
//         }
//       }
//     } catch (e) {
//       print("Erreur lors de la récupération de l'ID du chef: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (chefId == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Gestion des personnels'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     final userService = Provider.of<UserService>(context);
//     final logService = Provider.of<LogService>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion des personnels'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: userService.getPersonnelsByChef(chefId!),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Aucun personnel trouvé.'));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final personnel = snapshot.data![index];
//                 return _buildPersonnelCard(
//                     context, personnel, userService, logService);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddPersonnelDialog(context, userService, logService);
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blueAccent,
//       ),
//     );
//   }

//   // Construction de la carte pour chaque personnel
//   Widget _buildPersonnelCard(
//       BuildContext context,
//       Map<String, dynamic> personnel,
//       UserService userService,
//       LogService logService) {
//     return Card(
//       elevation: 5,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Titre avec le nom et prénom du personnel
//             Row(
//               children: [
//                 Icon(Icons.person, size: 40, color: Colors.blueAccent),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${personnel['nom']} ${personnel['prenom']}',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         personnel['email'],
//                         style:
//                             TextStyle(fontSize: 16.0, color: Colors.grey[700]),
//                       ),
//                       Text(
//                         'Rôle: ${personnel['role']}',
//                         style:
//                             TextStyle(fontSize: 16.0, color: Colors.grey[700]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'edit') {
//                       _showEditPersonnelDialog(
//                           context, personnel, userService, logService);
//                     } else if (value == 'delete') {
//                       _confirmDelete(
//                           context, personnel['id'], userService, logService);
//                     } else if (value == 'view') {
//                       // Navigation vers la page des détails de l'utilisateur
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DetailUtilisateurPage(
//                             personnel: personnel,
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   itemBuilder: (BuildContext context) {
//                     return [
//                       PopupMenuItem(
//                         value: 'view',
//                         child: Row(
//                           children: [
//                             Icon(Icons.info, color: Colors.blueAccent),
//                             SizedBox(width: 10),
//                             Text('Voir Détails'),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'edit',
//                         child: Row(
//                           children: [
//                             Icon(Icons.edit, color: Colors.blueAccent),
//                             SizedBox(width: 10),
//                             Text('Modifier'),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'delete',
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete, color: Colors.redAccent),
//                             SizedBox(width: 10),
//                             Text('Supprimer'),
//                           ],
//                         ),
//                       ),
//                     ];
//                   },
//                 ),

//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Dialog pour ajouter un personnel
//   void _showAddPersonnelDialog(BuildContext context, UserService userService,
//       LogService logService) async {
//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController nomController = TextEditingController();
//     final TextEditingController prenomController = TextEditingController();
//     final TextEditingController adresseController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();

//     final currentUser = FirebaseAuth.instance.currentUser;
//     final String chefId = currentUser!.uid;

//     try {
//       String localiteChef =
//           await userService.getLocaliteByRole(chefId) ?? 'Bamako';

//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: Text('Ajouter un personnel',
//               style: TextStyle(color: Colors.blueAccent)),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildTextField(nomController, 'Nom', Icons.person),
//                 _buildTextField(
//                     prenomController, 'Prénom', Icons.person_outline),
//                 _buildTextField(emailController, 'Email', Icons.email),
//                 _buildTextField(
//                     adresseController, 'Adresse', Icons.location_on),
//                 _buildTextField(passwordController, 'Mot de passe', Icons.lock,
//                     isPassword: true),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await userService.addPersonnel(
//                   email: emailController.text,
//                   password: passwordController.text,
//                   nom: nomController.text,
//                   prenom: prenomController.text,
//                   adresse: adresseController.text,
//                   localite: localiteChef,
//                   chefId: chefId,
//                 );
//                 await logService.logAction(
//                   action: 'Ajout personnel',
//                   details:
//                       'Personnel ${emailController.text} ajouté par ${currentUser.email}',
//                 );
//                 Navigator.of(ctx).pop();
//               },
//               child:
//                   Text('Ajouter', style: TextStyle(color: Colors.blueAccent)),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: Text('Annuler', style: TextStyle(color: Colors.redAccent)),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print("Erreur lors de la récupération de la localité du chef: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Erreur lors de la récupération de la localité."),
//       ));
//     }
//   }

//   // Construction d'un champ texte réutilisable
//   Widget _buildTextField(
//       TextEditingController controller, String label, IconData icon,
//       {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           filled: true,
//           fillColor: Colors.grey[200],
//         ),
//       ),
//     );
//   }

//   // Confirmation de suppression
//   void _confirmDelete(BuildContext context, String personnelId,
//       UserService userService, LogService logService) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Confirmer la suppression'),
//         content: Text('Voulez-vous vraiment supprimer cet utilisateur ?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Annuler', style: TextStyle(color: Colors.blueAccent)),
//           ),
//           TextButton(
//             onPressed: () async {
//               await userService.deleteUser(personnelId);
//               await logService.logAction(
//                 action: 'Suppression du personnel',
//                 details:
//                     'Personnel supprimé par ${FirebaseAuth.instance.currentUser!.email}',
//               );
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
//           ),
//         ],
//       ),
//     );
//   }

//   // Dialog pour éditer un personnel
//   void _showEditPersonnelDialog(
//       BuildContext context,
//       Map<String, dynamic> personnel,
//       UserService userService,
//       LogService logService) {
//     final TextEditingController emailController =
//         TextEditingController(text: personnel['email']);
//     final TextEditingController nomController =
//         TextEditingController(text: personnel['nom']);
//     final TextEditingController prenomController =
//         TextEditingController(text: personnel['prenom']);
//     final TextEditingController adresseController =
//         TextEditingController(text: personnel['adresse']);
//     final TextEditingController passwordController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Modifier le personnel'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildTextField(nomController, 'Nom', Icons.person),
//             _buildTextField(prenomController, 'Prénom', Icons.person_outline),
//             _buildTextField(emailController, 'Email', Icons.email),
//             _buildTextField(adresseController, 'Adresse', Icons.location_on),
//             _buildTextField(passwordController, 'Mot de passe', Icons.lock,
//                 isPassword: true)
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               final updates = {
//                 'email': emailController.text,
//                 'nom': nomController.text,
//                 'prenom': prenomController.text,
//                 'adresse': adresseController.text,
//               };
//               if (passwordController.text.isNotEmpty) {
//                 updates['password'] = passwordController.text;
//               }
//               await userService.updateUser(personnel['id'], updates);
//               await logService.logAction(
//                 action: 'Modification personnel',
//                 details:
//                     'Personnel ${emailController.text} modifié par ${FirebaseAuth.instance.currentUser!.email}',
//               );
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Modifier', style: TextStyle(color: Colors.blueAccent)),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Annuler', style: TextStyle(color: Colors.redAccent)),
//           ),
//         ],
//       ),
//     );
//   }
// }










import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:terrain/pages/chefpersonnel/detail_utilisateur.dart';
import 'package:terrain/services/hist_service.dart';
import 'package:terrain/services/user_service.dart';

class PersonnelManagementPage extends StatefulWidget {
  @override
  _PersonnelManagementPageState createState() =>
      _PersonnelManagementPageState();
}

class _PersonnelManagementPageState extends State<PersonnelManagementPage> {
  String? chefId;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadChefId();
  }

  Future<void> _loadChefId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc['role'] == 'chef_personnel') {
          setState(() {
            chefId = currentUser.uid;
          });
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'ID du chef: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final logService = Provider.of<LogService>(context, listen: false);

return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Gestion des personnels'),
        
        // backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
           
          ),
        ],
      ),
      body: chefId == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: userService.getPersonnelsByChef(chefId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun personnel trouvé.'));
                }

return LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Liste des personnels',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              ElevatedButton(
                                onPressed: () {
                                  _showAddPersonnelDialog(
                                      context, userService, logService);
                                },
                                child: Text('Ajouter un personnel'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection:
                                Axis.vertical, // Gère le défilement vertical
                            child: SingleChildScrollView(
                              scrollDirection: Axis
                                  .horizontal, // Gère le défilement horizontal
                              child: SizedBox(
                                width: constraints
                                    .maxWidth, // Prend toute la largeur de l'écran
                                child: PaginatedDataTable(
                                  header: Text(''), // En-tête du tableau
                                  columns:
                                      _createColumns(), // Création des colonnes
                                  source: _PersonnelDataSource(snapshot.data!,
                                      context,
                                      logService), // Source des données
                                  rowsPerPage: _rowsPerPage, // Lignes par page
                                  availableRowsPerPage: [
                                    5,
                                    10,
                                    20
                                  ], // Options de pagination
                                  onRowsPerPageChanged: (value) {
                                    setState(() {
                                      _rowsPerPage = value ?? _rowsPerPage;
                                    });
                                  },
                                  sortColumnIndex:
                                      _sortColumnIndex, // Colonne pour le tri
                                  sortAscending: _sortAscending, // Ordre de tri
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );

              },
            ),
    );


  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Nom')),
      DataColumn(label: Text('Prénom')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Actions')),
    ];
  }

  void _showAddPersonnelDialog(BuildContext context, UserService userService,
      LogService logService) async {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController nomController = TextEditingController();
    final TextEditingController prenomController = TextEditingController();
    final TextEditingController adresseController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final currentUser = FirebaseAuth.instance.currentUser;
    final String chefId = currentUser!.uid;

    try {
      String localiteChef =
          await userService.getLocaliteByRole(chefId) ?? 'Bamako';

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ajouter un personnel',
              style: TextStyle(color: Colors.blueAccent)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nomController, 'Nom', Icons.person),
                _buildTextField(
                    prenomController, 'Prénom', Icons.person_outline),
                _buildTextField(emailController, 'Email', Icons.email),
                _buildTextField(
                    adresseController, 'Adresse', Icons.location_on),
                _buildTextField(passwordController, 'Mot de passe', Icons.lock,
                    isPassword: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await userService.addPersonnel(
                  email: emailController.text,
                  password: passwordController.text,
                  nom: nomController.text,
                  prenom: prenomController.text,
                  adresse: adresseController.text,
                  localite: localiteChef,
                  chefId: chefId,
                );
                await logService.logAction(
                  action: 'Ajout',
                  details:
                      'Personnel ${emailController.text} ajouté par ${currentUser.email}',
                  userId: currentUser
                      .uid, // ID de l'utilisateur actuel (chef de personnel)
                  
                      // ID de l'utilisateur ajouté (nouveau personnel)
                  role:
                      'chef_personnel', // Rôle de celui qui fait l'ajout (chef de personnel)
                );


                Navigator.of(ctx).pop();
              },
              child:
                  Text('Ajouter', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Annuler', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Erreur lors de la récupération de la localité du chef: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors de la récupération de la localité."),
      ));
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}

class _PersonnelDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _personnels;
  final BuildContext _context;
  final  LogService logService ;

  _PersonnelDataSource(this._personnels, this._context, this.logService );

  

  @override
  DataRow? getRow(int index) {
    if (index >= _personnels.length) return null;
    final personnel = _personnels[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(personnel['nom'] ?? 'Nom non disponible')),
      DataCell(Text(personnel['prenom'] ?? 'Prénom non disponible')),
      DataCell(Text(personnel['email'] ?? 'Email non disponible')),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                _context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailUtilisateurPage(personnel: personnel),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.green),
            onPressed: () {
              _showEditPersonnelDialog(_context, personnel, logService);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _Deleteperso(_context, personnel['id'], logService);
            },
          ),
        ],
      )),
    ]);

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _personnels.length;

  @override
  int get selectedRowCount => 0;


    // Méthode pour afficher un dialogue de confirmation de suppression
  void _Deleteperso(
      BuildContext context, String personnelId, LogService logService) {
    final currentUser = FirebaseAuth.instance.currentUser;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer cet utilisateur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Annuler', style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () async {
              final userService =
                  Provider.of<UserService>(context, listen: false);

              // Supprimer l'utilisateur
              await userService.deleteUser(personnelId);

              // Enregistrer l'action de suppression dans le log
              await logService.logAction(
                action: 'Suppression',
                details:
                    'Personnel avec ID $personnelId supprimé par ${currentUser?.email}',
                userId: currentUser!.uid,
                role:
                    'chef_personnel', // Rôle de l'utilisateur qui effectue la suppression
              );

              Navigator.of(ctx).pop();
            },
            child: Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }


  // Méthode pour afficher un dialogue de modification du personnel
  void _showEditPersonnelDialog(BuildContext context, Map<String, dynamic> personnel,  LogService logService ) {
    final TextEditingController emailController = TextEditingController(text: personnel['email']);
    final TextEditingController nomController = TextEditingController(text: personnel['nom']);
    final TextEditingController prenomController = TextEditingController(text: personnel['prenom']);
    final TextEditingController adresseController = TextEditingController(text: personnel['adresse']);
    final TextEditingController passwordController = TextEditingController();
        final currentUser = FirebaseAuth.instance.currentUser;
    final String chefId = currentUser!.uid;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Modifier le personnel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nomController, 'Nom', Icons.person),
            _buildTextField(prenomController, 'Prénom', Icons.person_outline),
            _buildTextField(emailController, 'Email', Icons.email),
            _buildTextField(adresseController, 'Adresse', Icons.location_on),
            _buildTextField(passwordController, 'Mot de passe', Icons.lock, isPassword: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final userService = Provider.of<UserService>(context, listen: false);
              final updates = {
                'email': emailController.text,
                'nom': nomController.text,
                'prenom': prenomController.text,
                'adresse': adresseController.text,
              };
              if (passwordController.text.isNotEmpty) {
                updates['password'] = passwordController.text;
              }
              await userService.updateUser(personnel['id'], updates);
              await logService.logAction(
                action: 'Modification',
                details:
                    'Personnel ${emailController.text} modifier par ${currentUser.email}',
                userId: currentUser
                    .uid, // ID de l'utilisateur actuel (chef de personnel)

                // ID de l'utilisateur ajouté (nouveau personnel)
                role:
                    'chef_personnel', // Rôle de celui qui fait l'ajout (chef de personnel)
              );
              
              Navigator.of(ctx).pop();
            },
            child: Text('Modifier', style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Annuler', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
  
  // Construction d'un champ texte réutilisable
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
  
}



    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Gestion des personnels'),
    //     backgroundColor: Colors.blueAccent,
    //     actions: [
    //       Padding(
    //         padding: const EdgeInsets.only(right: 16.0),
    //         child: ElevatedButton.icon(
    //           onPressed: () {
    //             _showAddPersonnelDialog(context, userService, logService);
    //           },
    //           icon: Icon(Icons.add, color: Colors.white),
    //           label: Text(
    //             'Ajouter un personnel',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Colors.blueAccent,
    //             padding: EdgeInsets.symmetric(horizontal: 16.0),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body: chefId == null
    //       ? Center(child: CircularProgressIndicator())
    //       : FutureBuilder<List<Map<String, dynamic>>>(
    //           future: userService.getPersonnelsByChef(chefId!),
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return Center(child: CircularProgressIndicator());
    //             }
    //             if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //               return Center(child: Text('Aucun personnel trouvé.'));
    //             }

    //             return SingleChildScrollView(
    //               scrollDirection: Axis.horizontal,
    //               child: SizedBox(
    //                 width: MediaQuery.of(context)
    //                     .size
    //                     .width, // S'assurer que la table occupe toute la largeur disponible
    //                 child: PaginatedDataTable(
    //                   columns: _createColumns(),
    //                   source: _PersonnelDataSource(snapshot.data!, context),
    //                   rowsPerPage: _rowsPerPage,
    //                   availableRowsPerPage: [5, 10, 20],
    //                   onRowsPerPageChanged: (value) {
    //                     setState(() {
    //                       _rowsPerPage = value ?? _rowsPerPage;
    //                     });
    //                   },
    //                   sortColumnIndex: _sortColumnIndex,
    //                   sortAscending: _sortAscending,
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    // );