import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DashboardDemandeurPage extends StatefulWidget {
  @override
  _DashboardDemandeurPageState createState() => _DashboardDemandeurPageState();
}

class _DashboardDemandeurPageState extends State<DashboardDemandeurPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Déjà sur l'accueil
        break;
      case 1:
        Navigator.pushNamed(context, '/demandes');
        break;
      case 2:
        Navigator.pushNamed(context, '/conseils');
        break;
      case 3:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Assurez-vous que l'image existe
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COUCOU !',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    'Abdalla Guindo',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    overflow:
                        TextOverflow.ellipsis, // Évite l'overflow du texte
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Action pour les notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.purple),
            onPressed: () {
              // Action pour accéder au profil
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche pour le numéro Ninacad
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.purple),
                hintText:
                    'Entrer votre numéro Ninacad pour voir votre parcelle ?',
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Message de bienvenue
                    Text(
                      'Bienvenue sur Mon Terrain',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Découvrez les avantages de Mon Terrain et vérifiez vos parcelles facilement.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center, // Centrer le texte
                    ),
                    SizedBox(height: 20),

                    // Image avec bouton pour soumettre une demande
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/Image1.png', // Remplace par ton image
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Texte sous l'image pour soumettre une nouvelle demande
                    RichText(
                      textAlign: TextAlign.center, // Centrer le texte
                      text: TextSpan(
                        text: 'Appuyez ',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'ici',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/submit-demande');
                              },
                          ),
                          TextSpan(
                            text: ' pour soumettre une nouvelle demande',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Barre de navigation inférieure avec design personnalisé
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _currentIndex, // L'index de l'onglet actuellement sélectionné
        onTap: onTabTapped, // Fonction appelée lorsqu'un onglet est sélectionné
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.purple : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              color: _currentIndex == 1 ? Colors.purple : Colors.grey,
            ),
            label: 'Demande',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.support_agent,
              color: _currentIndex == 2 ? Colors.purple : Colors.grey,
            ),
            label: 'Conseils',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3 ? Colors.purple : Colors.grey,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:terrain/model/parcelle_model.dart';
// import 'package:terrain/services/parcelle_service.dart'; // Pour utiliser LatLng

// class DashboardDemandeurPage extends StatefulWidget {
//   @override
//   _DashboardDemandeurPageState createState() => _DashboardDemandeurPageState();
// }

// class _DashboardDemandeurPageState extends State<DashboardDemandeurPage> {
//   int _currentIndex = 0;
//   final ParcelleService parcelleService = ParcelleService();
//   List<Parcelle> parcelles = [];
//   TextEditingController searchController = TextEditingController();
//   LatLng? searchedLocation;
//   MapController _mapController = MapController();

//   @override
//   void initState() {
//     super.initState();
//     loadParcelles();
//   }

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         break; // Déjà sur l'accueil
//       case 1:
//         Navigator.pushNamed(context, '/demandes');
//         break;
//       case 2:
//         Navigator.pushNamed(context, '/conseils');
//         break;
//       case 3:
//         Navigator.pushNamed(context, '/profil');
//         break;
//     }
//   }

//   Future<void> loadParcelles() async {
//     List<Parcelle> fetchedParcelles = await parcelleService.getAllParcelles();
//     setState(() {
//       parcelles = fetchedParcelles;
//     });
//   }

//   void searchParcelle() {
//     final query = searchController.text;
//     final foundParcelle = parcelles.firstWhere(
//       (parcelle) => parcelle.numParcelleOuTitre.toString() == query,
//       orElse: () => Parcelle(
//           id: '',
//           nomProprietaire: '',
//           prenomProprietaire: '',
//           addresseProprietaire: '',
//           numParcelleOuTitre: 0,
//           numEnregFolios: 0,
//           superficieTerrain: '',
//           lieuParcelle: '',
//           planParcelle: '',
//           coutMoyenParcelle: '',
//           latitude: 0,
//           longitude: 0),
//     );

//     if (foundParcelle.id.isNotEmpty) {
//       setState(() {
//         searchedLocation =
//             LatLng(foundParcelle.latitude, foundParcelle.longitude);
//         _mapController.move(searchedLocation!, 15.0);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Parcelle non trouvée.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;
//     bool isLargeScreen = screenWidth > 600;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/logo.png',
//               width:
//                   screenWidth * 0.1, // Ajuste la taille du logo selon l'écran
//               height: screenHeight * 0.05,
//             ),
//             SizedBox(width: 10),
//             Flexible(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'COUCOU !',
//                     style: TextStyle(
//                         color: Colors.black, fontSize: screenWidth * 0.03),
//                   ),
//                   Text(
//                     'Abdalla Guindo',
//                     style: TextStyle(
//                         color: Colors.black, fontSize: screenWidth * 0.05),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications,
//                 color: Colors.black, size: screenWidth * 0.07),
//             onPressed: () {
//               // Action pour les notifications
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.account_circle,
//                 color: Colors.purple, size: screenWidth * 0.07),
//             onPressed: () {
//               // Action pour accéder au profil
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         // Permettre le défilement
//         child: Column(
//           children: [
//             // Barre de recherche pour le numéro de parcelle
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search,
//                       color: Colors.purple, size: screenWidth * 0.07),
//                   hintText:
//                       'Entrer le numéro de parcelle pour voir l\'emplacement',
//                   filled: true,
//                   fillColor: Colors.purple[50],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 onSubmitted: (_) => searchParcelle(),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Carte interactive
//                   Container(
//                     height:
//                         isLargeScreen ? screenHeight * 0.5 : screenHeight * 0.3,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: FlutterMap(
//                         mapController: _mapController,
//                         options: MapOptions(
//                           center: searchedLocation ?? LatLng(12.6392, -8.0029),
//                           zoom: 13.0,
//                         ),
//                         children: [
//                           TileLayer(
//                             urlTemplate:
//                                 "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                             subdomains: ['a', 'b', 'c'],
//                           ),
//                           if (searchedLocation != null)
//                             MarkerLayer(
//                               markers: [
//                                 Marker(
//                                   width: 80.0,
//                                   height: 80.0,
//                                   point: searchedLocation!,
//                                   builder: (ctx) => Icon(
//                                     Icons.location_pin,
//                                     color: Colors.red,
//                                     size: screenWidth * 0.08,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // Barre de navigation inférieure avec design personnalisé
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: onTabTapped,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: _currentIndex == 0 ? Colors.purple : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.assignment,
//               color: _currentIndex == 1 ? Colors.purple : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Demande',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.support_agent,
//               color: _currentIndex == 2 ? Colors.purple : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Conseils',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//               color: _currentIndex == 3 ? Colors.purple : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Profil',
//           ),
//         ],
//       ),
//     );
//   }
// }



