import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/widgets/bar_nav_pers.dart';
import 'package:terrain/widgets/contenudahchef.dart';

class PersonnelProfilePage extends StatefulWidget {
  @override
  _PersonnelProfilePageState createState() => _PersonnelProfilePageState();
}

class _PersonnelProfilePageState extends State<PersonnelProfilePage> {
  int _currentIndex =
      2; // Index pour indiquer que nous sommes sur la page Profil

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurprincipale,
        title: Text('Mon Profil'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: couleurprincipale),
            SizedBox(height: 20),
            Text(
              'Nom: ${user?.displayName ?? 'Nom inconnu'}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${user?.email ?? 'Email inconnu'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBarp(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
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
