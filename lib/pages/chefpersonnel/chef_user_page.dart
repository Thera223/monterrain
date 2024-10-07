import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (chefId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Gestion des personnels'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final userService = Provider.of<UserService>(context);
    final logService = Provider.of<LogService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des personnels'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userService.getPersonnelsByChef(chefId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun personnel trouvé.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final personnel = snapshot.data![index];
                return _buildPersonnelCard(
                    context, personnel, userService, logService);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPersonnelDialog(context, userService, logService);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Construction de la carte pour chaque personnel
  Widget _buildPersonnelCard(
      BuildContext context,
      Map<String, dynamic> personnel,
      UserService userService,
      LogService logService) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre avec le nom et prénom du personnel
            Row(
              children: [
                Icon(Icons.person, size: 40, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${personnel['nom']} ${personnel['prenom']}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        personnel['email'],
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                      ),
                      Text(
                        'Rôle: ${personnel['role']}',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditPersonnelDialog(
                          context, personnel, userService, logService);
                    } else if (value == 'delete') {
                      _confirmDelete(
                          context, personnel['id'], userService, logService);
                    } else if (value == 'view') {
                      // Navigation vers la page des détails de l'utilisateur
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailUtilisateurPage(
                            personnel: personnel,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blueAccent),
                            SizedBox(width: 10),
                            Text('Voir Détails'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blueAccent),
                            SizedBox(width: 10),
                            Text('Modifier'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.redAccent),
                            SizedBox(width: 10),
                            Text('Supprimer'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dialog pour ajouter un personnel
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
                  action: 'Ajout personnel',
                  details:
                      'Personnel ${emailController.text} ajouté par ${currentUser.email}',
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

  // Construction d'un champ texte réutilisable
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

  // Confirmation de suppression
  void _confirmDelete(BuildContext context, String personnelId,
      UserService userService, LogService logService) {
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
              await userService.deleteUser(personnelId);
              await logService.logAction(
                action: 'Suppression du personnel',
                details:
                    'Personnel supprimé par ${FirebaseAuth.instance.currentUser!.email}',
              );
              Navigator.of(ctx).pop();
            },
            child: Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // Dialog pour éditer un personnel
  void _showEditPersonnelDialog(
      BuildContext context,
      Map<String, dynamic> personnel,
      UserService userService,
      LogService logService) {
    final TextEditingController emailController =
        TextEditingController(text: personnel['email']);
    final TextEditingController nomController =
        TextEditingController(text: personnel['nom']);
    final TextEditingController prenomController =
        TextEditingController(text: personnel['prenom']);
    final TextEditingController adresseController =
        TextEditingController(text: personnel['adresse']);
    final TextEditingController passwordController = TextEditingController();

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
            _buildTextField(passwordController, 'Mot de passe', Icons.lock,
                isPassword: true)
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
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
                action: 'Modification personnel',
                details:
                    'Personnel ${emailController.text} modifié par ${FirebaseAuth.instance.currentUser!.email}',
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
}
