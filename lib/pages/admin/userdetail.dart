import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  final Map<String, dynamic> user;

  UserDetailsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'utilisateur'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom et Prénom
            _buildDetailRow('Nom', '${user['nom']} ${user['prenom']}'),
            SizedBox(height: 10),
            // Email
            _buildDetailRow('Email', user['email']),
            SizedBox(height: 10),
            // Rôle
            _buildDetailRow('Rôle', user['role']),
            SizedBox(height: 10),
            // Localité (s'il s'agit d'un chef personnel)
            if (user['role'] == 'chef_personnel')
              _buildDetailRow('Localité', user['localite'] ?? 'Non défini'),
            // Date de création (exemple si vous avez des informations temporelles)
            if (user.containsKey('createdAt'))
              _buildDetailRow('Créé le',
                  (user['createdAt'] as Timestamp).toDate().toString()),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher les détails sous forme de ligne
  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
