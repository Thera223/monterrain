import 'package:terrain/model/demande.dart';

// Future<void> _generatePDF(Demande demande) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) => pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text('Détails de la demande', style: pw.TextStyle(fontSize: 24)),
//           pw.SizedBox(height: 16),
//           pw.Text('ID Demande: ${demande.id}'),
//           pw.Text('Statut: ${demande.statut}'),
//           pw.Text(
//               'Types de demande: ${demande.typesDemande?.join(', ') ?? 'Non spécifié'}'),
//           pw.Text('Nom Propriétaire: ${demande.nomProprietaire}'),
//           pw.Text('Adresse Propriétaire: ${demande.adresseProprietaire}'),
//           pw.Text('Superficie Terrain: ${demande.superficieTerrain}'),
//           pw.Text('Lieu de la Parcelle: ${demande.lieuParcelle ?? 'Inconnu'}'),
//           pw.Text('Numéro Folios: ${demande.numFolios ?? 'Inconnu'}'),
//           pw.Text(
//               'Date de soumission: ${demande.dateSoumission?.toLocal() ?? 'Inconnue'}'),
//           pw.Text('Réponse: ${demande.reponse ?? 'Pas encore de réponse'}'),
//         ],
//       ),
//     ),
//   );

//   try {
//     // Demander l'autorisation de stockage
//     if (await Permission.storage.request().isGranted) {
//       // Récupérer le chemin pour stocker le fichier
//       final output = await getTemporaryDirectory();
//       final file = File("${output.path}/demande_${demande.id}.pdf");

//       // Sauvegarder le PDF
//       await file.writeAsBytes(await pdf.save());

//       // Informer l'utilisateur que le PDF a été téléchargé
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('PDF téléchargé : ${file.path}')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Permission de stockage refusée')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Erreur lors du téléchargement du PDF : $e')),
//     );
//   }}
