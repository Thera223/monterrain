import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 5, // Exemple de 5 notifications
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification ${index + 1}'),
            subtitle: Text('Détails de la notification...'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Supprimer la notification
              },
            ),
          );
        },
      ),
    );
  }
}
