// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/pages/admin/userdetail.dart';
// import 'package:terrain/services/hist_service.dart';
// import 'package:terrain/services/user_service.dart';

// class UsersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userService = Provider.of<UserService>(context);
//     final logService = Provider.of<LogService>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion des utilisateurs'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: userService.getUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Aucun utilisateur trouvé.'));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final user = snapshot.data![index];
//                 return _buildUserCard(context, user, userService, logService);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddChefDialog(context, userService);
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blueAccent,
//       ),
//     );
//   }

//   // Construction de la carte pour chaque utilisateur
//   Widget _buildUserCard(BuildContext context, Map<String, dynamic> user,
//       UserService userService, LogService logService) {
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
//             // Titre avec le nom et prénom de l'utilisateur
//             Row(
//               children: [
//                 Icon(Icons.person, size: 40, color: Colors.blueAccent),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${user['nom']} ${user['prenom']}',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         user['email'],
//                         style:
//                             TextStyle(fontSize: 16.0, color: Colors.grey[700]),
//                       ),
//                       Text(
//                         'Rôle: ${user['role']}',
//                         style:
//                             TextStyle(fontSize: 16.0, color: Colors.grey[700]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'edit') {
//                       _showEditUserDialog(
//                           context, userService, user, user['id']);
//                     } else if (value == 'delete') {
//                       _confirmDelete(
//                           context, user['id'], userService, logService);
//                     } else if (value == 'details') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => UserDetailsPage(user: user),
//                         ),
//                       );
//                     }
//                   },
//                   itemBuilder: (BuildContext context) {
//                     return [
//                       PopupMenuItem(
//                         value: 'details',
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

//   // Dialog pour ajouter un chef de personnel
//   void _showAddChefDialog(BuildContext context, UserService userService) {
//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController nomController = TextEditingController();
//     final TextEditingController prenomController = TextEditingController();
//     final TextEditingController adresseController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();
//     String selectedLocalite = 'Bamako'; // Localité par défaut

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Ajouter un chef de personnel'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildTextField(nomController, 'Nom', Icons.person),
//               _buildTextField(prenomController, 'Prénom', Icons.person_outline),
//               _buildTextField(emailController, 'Email', Icons.email),
//               _buildTextField(adresseController, 'Adresse', Icons.location_on),
//               _buildTextField(passwordController, 'Mot de passe', Icons.lock,
//                   isPassword: true),
//               DropdownButtonFormField<String>(
//                 value: selectedLocalite,
//                 items: ['Bamako', 'Kati', 'Kayes', 'Koulikoro', 'Segou']
//                     .map((localite) => DropdownMenuItem(
//                           value: localite,
//                           child: Text(localite),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   selectedLocalite = value!;
//                 },
//                 decoration: InputDecoration(labelText: 'Localité'),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await userService.addChefPersonnel(
//                 email: emailController.text,
//                 password: passwordController.text,
//                 nom: nomController.text,
//                 prenom: prenomController.text,
//                 adresse: adresseController.text,
//                 localite: selectedLocalite,
//               );
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Ajouter', style: TextStyle(color: Colors.blueAccent)),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Annuler', style: TextStyle(color: Colors.redAccent)),
//           ),
//         ],
//       ),
//     );
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
//   void _confirmDelete(BuildContext context, String userId,
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
//               await userService.deleteUser(userId);
//               await logService.logAction(
//                 action: 'Suppression d\'utilisateur',
//                 details:
//                     'Utilisateur supprimé par ${FirebaseAuth.instance.currentUser!.email}',
//               );
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
//           ),
//         ],
//       ),
//     );
//   }

//   // Dialog pour modifier un utilisateur
//   void _showEditUserDialog(BuildContext context, UserService userService,
//       Map<String, dynamic> user, String userId) {
//     final TextEditingController emailController =
//         TextEditingController(text: user['email']);
//     final TextEditingController nomController =
//         TextEditingController(text: user['nom']);
//     final TextEditingController prenomController =
//         TextEditingController(text: user['prenom']);
//     final TextEditingController adresseController =
//         TextEditingController(text: user['adresse']);
//     final TextEditingController passwordController = TextEditingController();
//     final TextEditingController localiteController = TextEditingController(
//         text: user['localite'] ?? ''); // Charge la localité si elle existe
//     String role = user['role'];

//     showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Modifier l\'utilisateur'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildTextField(nomController, 'Nom', Icons.person),
//                 _buildTextField(
//                     prenomController, 'Prénom', Icons.person_outline),
//                 _buildTextField(emailController, 'Email', Icons.email),
//                 _buildTextField(
//                     adresseController, 'Adresse', Icons.location_on),
//                 _buildTextField(
//                     passwordController,
//                     'Mot de passe (laisser vide pour ne pas changer)',
//                     Icons.lock,
//                     isPassword: true),
//                 DropdownButtonFormField<String>(
//                   value: role,
//                   items: ['demandeur', 'personnel', 'chef_personnel']
//                       .map((role) => DropdownMenuItem(
//                             value: role,
//                             child: Text(role),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       role = value ?? 'demandeur';
//                     });
//                   },
//                   decoration: InputDecoration(labelText: 'Rôle'),
//                 ),
//                 if (role == 'chef_personnel')
//                   _buildTextField(localiteController, 'Localité', Icons.map),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   final updates = {
//                     'email': emailController.text,
//                     'nom': nomController.text,
//                     'prenom': prenomController.text,
//                     'adresse': adresseController.text,
//                     'role': role,
//                   };
//                   if (passwordController.text.isNotEmpty) {
//                     updates['password'] = passwordController.text;
//                   }
//                   if (role == 'chef_personnel') {
//                     updates['localite'] =
//                         localiteController.text; // Ajoute localité
//                   }

//                   await userService.updateUser(userId, updates);
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text('Modifier',
//                     style: TextStyle(color: Colors.blueAccent)),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(ctx).pop(),
//                 child:
//                     Text('Annuler', style: TextStyle(color: Colors.redAccent)),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/pages/admin/userdetail.dart';
// import 'package:terrain/services/user_service.dart';

// class UsersPage extends StatefulWidget {
//   @override
//   _UsersPageState createState() => _UsersPageState();
// }

// class _UsersPageState extends State<UsersPage> {
//   int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
//   int _sortColumnIndex = 0;
//   bool _sortAscending = true;

//   @override
//   Widget build(BuildContext context) {
//     final userService = Provider.of<UserService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion des utilisateurs'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: userService.getUsersData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Aucun utilisateur trouvé.'));
//           }

//           return LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minWidth: constraints.maxWidth),
//                   child: PaginatedDataTable(
//                     header: Text('Liste des utilisateurs'),
//                     columns: _createColumns(),
//                     source: _UserDataSource(snapshot.data!, context),
//                     rowsPerPage: _rowsPerPage,
//                     availableRowsPerPage: [5, 10, 20],
//                     onRowsPerPageChanged: (value) {
//                       setState(() {
//                         _rowsPerPage = value ?? _rowsPerPage;
//                       });
//                     },
//                     sortColumnIndex: _sortColumnIndex,
//                     sortAscending: _sortAscending,
//                     onSelectAll: (isSelected) {
//                       setState(() {});
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Création des colonnes pour le tableau
//   List<DataColumn> _createColumns() {
//     return [
//       DataColumn(
//           label: Text('Nom'),
//           onSort: (index, ascending) {
//             setState(() {
//               _sortColumnIndex = index;
//               _sortAscending = ascending;
//             });
//           }),
//       DataColumn(label: Text('Email')),
//       DataColumn(label: Text('Rôle')),
//       DataColumn(label: Text('Actions')),
//     ];
//   }
// }

// // Source des données pour le tableau paginé
// class _UserDataSource extends DataTableSource {
//   final List<Map<String, dynamic>> _users;
//   final BuildContext _context;

//   _UserDataSource(this._users, this._context);

//   @override
//   DataRow? getRow(int index) {
//     if (index >= _users.length) return null;
//     final user = _users[index];

//     return DataRow.byIndex(index: index, cells: [
//       DataCell(Text('${user['nom']} ${user['prenom']}')),
//       DataCell(Text(user['email'])),
//       DataCell(Text(user['role'])),
//       DataCell(Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.info, color: Colors.blueAccent),
//             onPressed: () {
//               _navigateToDetailsPage(user);
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.edit, color: Colors.green),
//             onPressed: () {
//               _showEditUserDialog(_context, user);
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.delete, color: Colors.red),
//             onPressed: () {
//               _confirmDelete(_context, user['id']);
//             },
//           ),
//         ],
//       )),
//     ]);
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => _users.length;

//   @override
//   int get selectedRowCount => 0;

//   void _navigateToDetailsPage(Map<String, dynamic> user) {
//     Navigator.push(
//       _context,
//       MaterialPageRoute(
//         builder: (context) => UserDetailsPage(user: user),
//       ),
//     );
//   }

//   void _showEditUserDialog(BuildContext context, Map<String, dynamic> user) {
//     final TextEditingController nomController =
//         TextEditingController(text: user['nom']);
//     final TextEditingController prenomController =
//         TextEditingController(text: user['prenom']);
//     final TextEditingController emailController =
//         TextEditingController(text: user['email']);
//     final TextEditingController roleController =
//         TextEditingController(text: user['role']);

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Modifier l\'utilisateur'),
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
//               controller: roleController,
//               decoration: InputDecoration(labelText: 'Rôle'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               final updatedUser = {
//                 'nom': nomController.text,
//                 'prenom': prenomController.text,
//                 'email': emailController.text,
//                 'role': roleController.text,
//               };
//               final userService =
//                   Provider.of<UserService>(context, listen: false);
//               await userService.updateUser(user['id'], updatedUser);
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Modifier'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Annuler'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDelete(BuildContext context, String userId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Confirmer la suppression'),
//         content: Text('Voulez-vous vraiment supprimer cet utilisateur ?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('Annuler'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final userService =
//                   Provider.of<UserService>(context, listen: false);
//               await userService.deleteUser(userId);
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Supprimer'),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/admin/userdetail.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/user_service.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int _rowsPerPage = PaginatedDataTable
      .defaultRowsPerPage; // Nombre de lignes par page dans le tableau
  int _sortColumnIndex = 0; // Index de la colonne utilisée pour le tri
  bool _sortAscending = true; // Détermine si le tri est ascendant ou descendant

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(
        context); // Accès au service utilisateur via Provider

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Gestion des utilisateurs'), // Titre de la page
        // backgroundColor:couleurprincipale, // Couleur de l'AppBar
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userService
            .getUsersData(), // Récupère les données des utilisateurs depuis le service
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement si les données ne sont pas encore prêtes
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Message affiché si aucun utilisateur n'est trouvé
            return Center(child: Text('Aucun utilisateur trouvé.'));
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
                        Text('Liste des utilisateurs',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold)), // Titre de la liste
                        ElevatedButton(
                          onPressed: () {
                            _showAddChefDialog(context,
                                userService); // Ouvre le dialogue pour ajouter un chef de personnel
                          },
                          child: Text('Ajouter un chef de personnel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Forme du bouton
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints
                              .maxWidth, // S'assure que le tableau prend toute la largeur de l'écran
                        ),
                        child: PaginatedDataTable(
                          header: Text(''), // En-tête du tableau (vide ici)
                          columns:
                              _createColumns(), // Crée les colonnes du tableau
                          source: _UserDataSource(snapshot.data!,
                              context), // Source des données du tableau
                          rowsPerPage:
                              _rowsPerPage, // Nombre de lignes par page
                          availableRowsPerPage: [
                            5,
                            10,
                            20
                          ], // Options de pagination
                          onRowsPerPageChanged: (value) {
                            setState(() {
                              _rowsPerPage = value ??
                                  _rowsPerPage; // Modifie le nombre de lignes par page
                            });
                          },
                          sortColumnIndex:
                              _sortColumnIndex, // Indice de la colonne triée
                          sortAscending:
                              _sortAscending, // Tri ascendant ou descendant
                          onSelectAll: (isSelected) {
                            setState(
                                () {}); // Gère la sélection de toutes les lignes (non implémenté ici)
                          },
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

  // Crée les colonnes du tableau
  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Text('Nom'),
          onSort: (index, ascending) {
            setState(() {
              _sortColumnIndex = index; // Met à jour la colonne triée
              _sortAscending = ascending; // Met à jour le sens du tri
            });
          }),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Rôle')),
      DataColumn(label: Text('Actions')),
    ];
  }

  // Ouvre une boîte de dialogue pour ajouter un chef de personnel
  void _showAddChefDialog(BuildContext context, UserService userService) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController nomController = TextEditingController();
    final TextEditingController prenomController = TextEditingController();
    final TextEditingController adresseController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String selectedLocalite = 'Bamako'; // Valeur par défaut pour la localité

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            'Ajouter un chef de personnel'), // Titre de la boîte de dialogue
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Crée des champs texte pour entrer les informations
              _buildTextField(nomController, 'Nom', Icons.person),
              _buildTextField(prenomController, 'Prénom', Icons.person_outline),
              _buildTextField(emailController, 'Email', Icons.email),
              _buildTextField(adresseController, 'Adresse', Icons.location_on),
              _buildTextField(passwordController, 'Mot de passe', Icons.lock,
                  isPassword: true),
              DropdownButtonFormField<String>(
                value: selectedLocalite,
                items: ['Bamako', 'Kati', 'Kayes', 'Koulikoro', 'Segou']
                    .map((localite) => DropdownMenuItem(
                          value: localite,
                          child: Text(localite),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedLocalite = value!; // Modifie la localité sélectionnée
                },
                decoration: InputDecoration(labelText: 'Localité'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await userService.addChefPersonnel(
                email: emailController.text,
                password: passwordController.text,
                nom: nomController.text,
                prenom: prenomController.text,
                adresse: adresseController.text,
                localite: selectedLocalite,
              );
              Navigator.of(ctx)
                  .pop(); // Ferme la boîte de dialogue après l'ajout
            },
            child: Text('Ajouter', style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx)
                .pop(), // Ferme la boîte de dialogue sans action
            child: Text('Annuler', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // Crée un champ texte réutilisable avec des icônes
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword, // Masque le texte si c'est un mot de passe
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

// Source des données pour le tableau paginé
class _UserDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _users; // Liste des utilisateurs
  final BuildContext _context;

  _UserDataSource(this._users, this._context);

  @override
  DataRow? getRow(int index) {
    if (index >= _users.length) return null; // Vérifie l'index
    final user = _users[index];

    // Création d'une ligne dans le tableau avec les données de l'utilisateur
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text('${user['nom']} ${user['prenom']}')),
      DataCell(Text(user['email'])),
      DataCell(Text(user['role'])),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.blueAccent),
            onPressed: () {
              _navigateToDetailsPage(
                  user); // Affiche les détails de l'utilisateur
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.green),
            onPressed: () {
              _showEditUserDialog(
                  _context, user); // Ouvre le dialogue de modification
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _confirmDelete(
                  _context,
                  user[
                      'id']); // Ouvre le dialogue de confirmation de suppression
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate =>
      false; // Indique que le nombre de lignes est exact

  @override
  int get rowCount => _users.length; // Nombre total d'utilisateurs

   @override
  int get selectedRowCount =>
      0; // Nombre de lignes sélectionnées (ici, aucune sélection multiple n'est implémentée)

  // Navigation vers la page des détails d'un utilisateur
  void _navigateToDetailsPage(Map<String, dynamic> user) {
    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (context) =>
            UserDetailsPage(user: user), // Navigation vers la page des détails
      ),
    );
  }

  // Ouvre une boîte de dialogue pour modifier un utilisateur
  void _showEditUserDialog(BuildContext context, Map<String, dynamic> user) {
    final TextEditingController nomController = TextEditingController(
        text: user['nom']); // Remplit le champ nom avec la donnée existante
    final TextEditingController prenomController =
        TextEditingController(text: user['prenom']); // Remplit le champ prénom
    final TextEditingController emailController =
        TextEditingController(text: user['email']); // Remplit le champ email
    final TextEditingController roleController =
        TextEditingController(text: user['role']); // Remplit le champ rôle

    // Boîte de dialogue pour la modification des informations d'un utilisateur
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Modifier l\'utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController, // Champ de saisie pour le nom
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: prenomController, // Champ de saisie pour le prénom
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: emailController, // Champ de saisie pour l'email
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController, // Champ de saisie pour le rôle
              decoration: InputDecoration(labelText: 'Rôle'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedUser = {
                'nom': nomController.text, // Récupère le nom modifié
                'prenom': prenomController.text, // Récupère le prénom modifié
                'email': emailController.text, // Récupère l'email modifié
                'role': roleController.text, // Récupère le rôle modifié
              };
              final userService = Provider.of<UserService>(context,
                  listen: false); // Accès au service utilisateur
              await userService.updateUser(
                  user['id'], updatedUser); // Mise à jour de l'utilisateur
              Navigator.of(ctx)
                  .pop(); // Ferme la boîte de dialogue après modification
              // Rafraîchir les données après la mise à jour
            },
            child: Text('Modifier'), // Bouton pour confirmer la modification
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx)
                .pop(), // Ferme la boîte de dialogue sans modification
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }

  // Boîte de dialogue de confirmation de suppression
  void _confirmDelete(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text(
            'Voulez-vous vraiment supprimer cet utilisateur ?'), // Message de confirmation
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx)
                .pop(), // Annuler la suppression et fermer la boîte de dialogue
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final userService = Provider.of<UserService>(context,
                  listen: false); // Accès au service utilisateur
              await userService
                  .deleteUser(userId); // Suppression de l'utilisateur
              Navigator.of(ctx)
                  .pop(); // Ferme la boîte de dialogue après suppression
              // Rafraîchir les données après la suppression
            },
            child: Text('Supprimer',
                style: TextStyle(
                    color: Colors.red)), // Bouton pour confirmer la suppression
          ),
        ],
      ),
    );
  }
}
