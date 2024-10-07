import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonnelProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: Colors.purple),
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
    );
  }
}
