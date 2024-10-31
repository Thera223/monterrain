// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/services/demande_ser.dart';
// import 'package:terrain/model/demande.dart';

// class FiltersWidget extends StatefulWidget {
//   @override
//   _FiltersWidgetState createState() => _FiltersWidgetState();
// }

// class _FiltersWidgetState extends State<FiltersWidget> {
//   String? selectedStatut;
//   List<String> statuts = ['En attente', 'En cours', 'Répondu', 'Refusé'];
//   DateTimeRange? selectedDateRange;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         DropdownButton<String>(
//           hint: Text("Filtrer par statut"),
//           value: selectedStatut,
//           onChanged: (newValue) {
//             setState(() {
//               selectedStatut = newValue;
//               _filterDemandesByStatut(); // Filtrer les demandes par statut sélectionné
//             });
//           },
//           items: statuts.map((statut) {
//             return DropdownMenuItem(
//               value: statut,
//               child: Text(statut),
//             );
//           }).toList(),
//         ),
//         SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () async {
//             DateTimeRange? picked = await showDateRangePicker(
//               context: context,
//               firstDate: DateTime(2020),
//               lastDate: DateTime.now(),
//             );
//             if (picked != null) {
//               setState(() {
//                 selectedDateRange = picked;
//                 _filterDemandesByDate(); // Filtrer les demandes par période sélectionnée
//               });
//             }
//           },
//           child: Text(selectedDateRange == null
//               ? "Filtrer par période"
//               : "${selectedDateRange!.start.toLocal()} - ${selectedDateRange!.end.toLocal()}"),
//         ),
//       ],
//     );
//   }

//   Future<void> _filterDemandesByStatut() async {
//     final demandeService = Provider.of<DemandeService>(context, listen: false);
//     List<Demande> filteredDemandes =
//         await demandeService.getDemandesByStatut(selectedStatut!);

//     setState(() {
//       // Mettre à jour l'état avec les demandes filtrées
//     });
//   }

//   Future<void> _filterDemandesByDate() async {
//     final demandeService = Provider.of<DemandeService>(context, listen: false);
//     List<Demande> filteredDemandes = await demandeService.getDemandesByDate(
//       selectedDateRange!.start,
//       selectedDateRange!.end,
//     );

//     setState(() {
//       // Mettre à jour l'état avec les demandes filtrées par période
//     });
//   }
// }

import 'package:flutter/material.dart';

class FiltersWidget extends StatelessWidget {
  final Function(String) onFilterByStatut;
  final Function(DateTime, DateTime) onFilterByDate;

  FiltersWidget({required this.onFilterByStatut, required this.onFilterByDate});

  @override
  Widget build(BuildContext context) {
    String? selectedStatut;
    List<String> statuts = ['En attente', 'En cours', 'Répondu', 'Refusé'];
    DateTimeRange? selectedDateRange;

    return Column(
      children: [
        DropdownButton<String>(
          hint: Text("Filtrer par statut"),
          value: selectedStatut,
          onChanged: (newValue) {
            selectedStatut = newValue;
            onFilterByStatut(newValue!); // Appliquer le filtre de statut
          },
          items: statuts.map((statut) {
            return DropdownMenuItem(
              value: statut,
              child: Text(statut),
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              selectedDateRange = picked;
              onFilterByDate(
                  picked.start, picked.end); // Appliquer le filtre par période
            }
          },
          child: Text(selectedDateRange == null
              ? "Filtrer par période"
              : "${selectedDateRange!.start.toLocal()} - ${selectedDateRange!.end.toLocal()}"),
        ),
      ],
    );
  }
}
