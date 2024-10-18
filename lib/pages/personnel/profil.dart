// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore pour la récupération des données
// import 'package:terrain/pages/config_charte_coul.dart';
// import 'package:terrain/widgets/bar_nav_pers.dart';

// class PersonnelProfilePage extends StatefulWidget {
//   @override
//   _PersonnelProfilePageState createState() => _PersonnelProfilePageState();
// }

// class _PersonnelProfilePageState extends State<PersonnelProfilePage> {
//   int _currentIndex = 2; // Indiquer que nous sommes sur la page Profil
//   Map<String, dynamic>? userData; // Stocker les données de l'utilisateur
//   bool isLoading = true; // Indicateur de chargement

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData(); // Charger les données utilisateur au démarrage
//   }

//   // Méthode pour charger les données de l'utilisateur depuis Firestore
//   Future<void> _loadUserData() async {
//     final String userId =
//         FirebaseAuth.instance.currentUser!.uid; // Obtenir l'ID utilisateur
//     final userDoc = await getUserById(
//         userId); // Appel au service pour obtenir les données de l'utilisateur

//     if (userDoc != null) {
//       setState(() {
//         userData = userDoc;
//         isLoading = false; // Les données sont chargées
//       });
//     } else {
//       // Gérer le cas où les données de l'utilisateur ne sont pas trouvées
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Exemple de méthode pour obtenir un utilisateur via son ID
//   Future<Map<String, dynamic>?> getUserById(String userId) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
//           .instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (userDoc.exists) {
//         return userDoc.data(); // Retourner les données de l'utilisateur
//       }
//       return null; // Retourne null si l'utilisateur n'existe pas
//     } catch (e) {
//       print("Erreur lors de la récupération de l'utilisateur : $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: couleurprincipale,
//         title: Text('Mon Profil'),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? Center(
//               child:
//                   CircularProgressIndicator()) // Afficher un indicateur de chargement
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.person, size: 100, color: couleurprincipale),
//                   SizedBox(height: 20),

//                   // Afficher le nom de l'utilisateur récupéré depuis Firestore
//                   Text(
//                     'Nom: ${userData?['name'] ?? 'Nom inconnu'}',
//                     style: TextStyle(fontSize: 24),
//                   ),
//                   SizedBox(height: 10),

//                   // Afficher l'email de l'utilisateur récupéré depuis Firestore
//                   Text(
//                     'Email: ${userData?['email'] ?? 'Email inconnu'}',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 20),

//                   // Bouton pour se déconnecter
//                   ElevatedButton(
//                     onPressed: () {
//                       FirebaseAuth.instance.signOut();
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                     child: Text('Se déconnecter'),
//                   ),
//                 ],
//               ),
//             ),
//       bottomNavigationBar: CustomBottomNavBarp(
//         currentIndex: _currentIndex,
//         onTabTapped: onTabTapped,
//       ),
//     );
//   }

//   // Méthode pour gérer la navigation entre les pages
//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, '/personnel-mobile');
//         break;
//       case 1:
//         Navigator.pushNamed(context, '/personnel-demandes');
//         break;
//       case 2:
//         // Déjà sur la page de profil, donc pas de changement
//         break;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import nécessaire pour Firestore
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/widgets/bar_nav_pers.dart';

class PersonnelProfilePage extends StatefulWidget {
  @override
  _PersonnelProfilePageState createState() => _PersonnelProfilePageState();
}

class _PersonnelProfilePageState extends State<PersonnelProfilePage> {
  int _currentIndex = 2; // Page active : Profil
  Map<String, dynamic>? userData; // Stocker les données de l'utilisateur
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Charger les données utilisateur au démarrage
  }

  // Méthode pour charger les données de l'utilisateur depuis Firestore
  Future<void> _loadUserData() async {
    final String userId =
        FirebaseAuth.instance.currentUser!.uid; // Obtenir l'ID utilisateur
    final userDoc = await getUserById(
        userId); // Appel du service pour obtenir les données utilisateur

    if (userDoc != null) {
      setState(() {
        userData = userDoc;
        isLoading = false; // Les données sont chargées
      });
    } else {
      // Gérer le cas où les données utilisateur ne sont pas trouvées
      setState(() {
        isLoading = false;
      });
    }
  }

  // Exemple de méthode pour obtenir un utilisateur via son ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data(); // Retourne les données utilisateur
      }
      return null; // Retourne null si l'utilisateur n'existe pas
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: couleurprincipale,
        title: Text('Mon Profil'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Afficher un indicateur de chargement
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Avatar avec animation
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: CircleAvatar(
                        radius:
                            MediaQuery.of(context).size.width > 600 ? 60 : 40,
                        backgroundColor: couleurprincipale,
                        child: Icon(Icons.person,
                            size: MediaQuery.of(context).size.width > 600
                                ? 60
                                : 40,
                            color: Colors.white),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Ligne de séparation avec indicateur animé
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 8,
                      decoration: BoxDecoration(
                        color: couleurprincipale,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    // Champ Nom (utilise le nom de l'utilisateur récupéré)
                    _buildProfileField(
                        'Nom',
                        userData?['nom'] ?? 'Nom inconnu',
                        Icons.person_outline,
                        MediaQuery.of(context).size.width),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Champ Email (utilise l'email de l'utilisateur récupéré)
                    _buildProfileField(
                        'E-mail',
                        userData?['email'] ?? 'Email inconnu',
                        Icons.email_outlined,
                        MediaQuery.of(context).size.width),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Champ Téléphone (utilise le numéro de téléphone récupéré)
                    _buildProfileField(
                        'Téléphone',
                        userData?['phone'] ?? 'Téléphone non spécifié',
                        Icons.phone_outlined,
                        MediaQuery.of(context).size.width),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    // Bouton Se déconnecter avec animation
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: Icon(Icons.logout, color: couleurprincipale),
                      label: Text('Se déconnecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: couleurprincipale.withOpacity(0.1),
                        foregroundColor: couleurprincipale,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavBarp(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }

  // Fonction utilitaire pour construire un champ de profil
  Widget _buildProfileField(
      String label, String value, IconData icon, double screenWidth) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // Méthode pour gérer la navigation entre les pages
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/personnel-mobile');
        break;
      case 1:
        Navigator.pushNamed(context, '/personnel-demandes');
        break;
      case 2:
        // Déjà sur la page de profil, donc pas de changement
        break;
    }
  }
}
