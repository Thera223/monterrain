import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/admin/userdetail.dart';
import 'package:terrain/services/hist_service.dart';
import 'package:terrain/services/user_service.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final logService = Provider.of<LogService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des utilisateurs'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: userService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return _buildUserCard(context, user, userService, logService);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddChefDialog(context, userService);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Construction de la carte pour chaque utilisateur
  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user,
      UserService userService, LogService logService) {
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
            // Titre avec le nom et prénom de l'utilisateur
            Row(
              children: [
                Icon(Icons.person, size: 40, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user['nom']} ${user['prenom']}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user['email'],
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                      ),
                      Text(
                        'Rôle: ${user['role']}',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditUserDialog(
                          context, userService, user, user['id']);
                    } else if (value == 'delete') {
                      _confirmDelete(
                          context, user['id'], userService, logService);
                    } else if (value == 'details') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(user: user),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'details',
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

  // Dialog pour ajouter un chef de personnel
  void _showAddChefDialog(BuildContext context, UserService userService) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController nomController = TextEditingController();
    final TextEditingController prenomController = TextEditingController();
    final TextEditingController adresseController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String selectedLocalite = 'Bamako'; // Localité par défaut

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ajouter un chef de personnel'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  selectedLocalite = value!;
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
              Navigator.of(ctx).pop();
            },
            child: Text('Ajouter', style: TextStyle(color: Colors.blueAccent)),
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
  void _confirmDelete(BuildContext context, String userId,
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
              await userService.deleteUser(userId);
              await logService.logAction(
                action: 'Suppression d\'utilisateur',
                details:
                    'Utilisateur supprimé par ${FirebaseAuth.instance.currentUser!.email}',
              );
              Navigator.of(ctx).pop();
            },
            child: Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // Dialog pour modifier un utilisateur
  void _showEditUserDialog(BuildContext context, UserService userService,
      Map<String, dynamic> user, String userId) {
    final TextEditingController emailController =
        TextEditingController(text: user['email']);
    final TextEditingController nomController =
        TextEditingController(text: user['nom']);
    final TextEditingController prenomController =
        TextEditingController(text: user['prenom']);
    final TextEditingController adresseController =
        TextEditingController(text: user['adresse']);
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController localiteController = TextEditingController(
        text: user['localite'] ?? ''); // Charge la localité si elle existe
    String role = user['role'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Modifier l\'utilisateur'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nomController, 'Nom', Icons.person),
                _buildTextField(
                    prenomController, 'Prénom', Icons.person_outline),
                _buildTextField(emailController, 'Email', Icons.email),
                _buildTextField(
                    adresseController, 'Adresse', Icons.location_on),
                _buildTextField(
                    passwordController,
                    'Mot de passe (laisser vide pour ne pas changer)',
                    Icons.lock,
                    isPassword: true),
                DropdownButtonFormField<String>(
                  value: role,
                  items: ['demandeur', 'personnel', 'chef_personnel']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      role = value ?? 'demandeur';
                    });
                  },
                  decoration: InputDecoration(labelText: 'Rôle'),
                ),
                if (role == 'chef_personnel')
                  _buildTextField(localiteController, 'Localité', Icons.map),
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
                    'role': role,
                  };
                  if (passwordController.text.isNotEmpty) {
                    updates['password'] = passwordController.text;
                  }
                  if (role == 'chef_personnel') {
                    updates['localite'] =
                        localiteController.text; // Ajoute localité
                  }

                  await userService.updateUser(userId, updates);
                  Navigator.of(ctx).pop();
                },
                child: Text('Modifier',
                    style: TextStyle(color: Colors.blueAccent)),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child:
                    Text('Annuler', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          );
        },
      ),
    );
  }
}
