import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/services/hist_service.dart';

class LogsPage extends StatefulWidget {
  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String selectedAction = 'Toutes'; // Action sélectionnée par défaut

  @override
  Widget build(BuildContext context) {
    final logService = Provider.of<LogService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des actions'),
      ),
      body: Column(
        children: [
          // Dropdown pour sélectionner l'action à filtrer
          DropdownButton<String>(
            value: selectedAction,
            items: ['Toutes', 'Ajout', 'Modification', 'Suppression']
                .map((action) => DropdownMenuItem(
                      value: action,
                      child: Text(action),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedAction = value!;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: logService.getLogsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final logs = snapshot.data!.docs;

                // Filtrer les logs selon l'action sélectionnée
                final filteredLogs = selectedAction == 'Toutes'
                    ? logs
                    : logs.where((log) {
                        return log['action'] == selectedAction;
                      }).toList();

                return ListView.builder(
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    return ListTile(
                      title: Text('Action: ${log['action']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Détails: ${log['details']}'),
                          Text('Utilisateur: ${log['userId']}'),
                          Text('Rôle: ${log['role']}'),
                        ],
                      ),
                      trailing: Text(
                        (log['timestamp'] as Timestamp).toDate().toString(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
