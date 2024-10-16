// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:terrain/model/parcelle_model.dart';
// import 'package:terrain/services/parcelle_service.dart';

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
//   String? coutMoyenParcelle;
//   String? lieuParcelle;
//   String? superficieParcelle;
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
//         break;
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

//   void searchParcelle() async {
//     final query = searchController.text;

//     if (query.isEmpty) {
//       setState(() {
//         searchedLocation = null;
//         _mapController.move(LatLng(12.6392, -8.0029), 13.0);
//         coutMoyenParcelle = '';
//         lieuParcelle = '';
//         superficieParcelle = '';
//       });
//       return;
//     }

//     final foundParcelle = parcelles.firstWhere(
//       (parcelle) => parcelle.numParcelleOuTitre.toString() == query,
//       orElse: () => Parcelle(
//         id: '',
//         nomProprietaire: '',
//         prenomProprietaire: '',
//         addresseProprietaire: '',
//         numParcelleOuTitre: 0,
//         numEnregFolios: 0,
//         superficieTerrain: '',
//         lieuParcelle: '',
//         planParcelle: '',
//         coutMoyenParcelle: '',
//         latitude: 0,
//         longitude: 0,
//         verification: false,
//         litige: false,
//         historiqueTransactions: [],
//       ),
//     );

//     if (foundParcelle.id.isNotEmpty) {
//       setState(() {
//         searchedLocation =
//             LatLng(foundParcelle.latitude, foundParcelle.longitude);
//         coutMoyenParcelle = foundParcelle.coutMoyenParcelle;
//         lieuParcelle = foundParcelle.lieuParcelle;
//         superficieParcelle = foundParcelle.superficieTerrain;
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

//         backgroundColor: const Color.fromARGB(255, 156, 39, 176),
//         elevation: 0,
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/logo.png',
//               width: screenWidth * 0.1,
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
//                         color: Colors.white, fontSize: screenWidth * 0.03),
//                   ),
//                   Text(
//                     'Abdalla Guindo',
//                     style: TextStyle(
//                         color: Colors.white, fontSize: screenWidth * 0.05),
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
//                 color: Colors.white, size: screenWidth * 0.07),
//             onPressed: () {
//               // Action pour les notifications
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.account_circle,
//                 color: Colors.white, size: screenWidth * 0.07),
//             onPressed: () {
//               // Action pour accéder au profil
//             },
//           ),
//         ],
//       ),
//       body:
//       SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search,
//                       color:couleurprincipale, size: screenWidth * 0.07),
//                   hintText:
//                       'Entrer le numéro de parcelle pour voir l\'emplacement',
//                   filled: true,
//                   fillColor:couleurprincipale[50],
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
//                   if (coutMoyenParcelle != null &&
//                       lieuParcelle != null &&
//                       superficieParcelle != null &&
//                       coutMoyenParcelle!.isNotEmpty &&
//                       lieuParcelle!.isNotEmpty &&
//                       superficieParcelle!.isNotEmpty)
//                     Card(
//                       margin: EdgeInsets.all(8),
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.monetization_on,
//                                     color: Colors.green,
//                                     size: screenWidth * 0.06),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   'Coût moyen : $coutMoyenParcelle',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: screenWidth * 0.045,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Icon(Icons.location_on,
//                                     color: Colors.red,
//                                     size: screenWidth * 0.06),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   'Lieu : $lieuParcelle',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: screenWidth * 0.045),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Icon(Icons.square_foot,
//                                     color: Colors.blue,
//                                     size: screenWidth * 0.06),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   'Superficie : $superficieParcelle',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: screenWidth * 0.045),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
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
//         selectedItemColor:couleurprincipale,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//                items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: _currentIndex == 0 ?couleurprincipale : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.assignment,
//               color: _currentIndex == 1 ? const Color.fromARGB(255, 156, 39, 176) : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Demande',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.support_agent,
//               color: _currentIndex == 2 ?couleurprincipale : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Conseils',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//               color: _currentIndex == 3 ?couleurprincipale : Colors.grey,
//               size: screenWidth * 0.07,
//             ),
//             label: 'Profil',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:terrain/model/parcelle_model.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/services/parcelle_service.dart';
import 'package:terrain/widgets/contenudahchef.dart';

class DashboardDemandeurPage extends StatefulWidget {
  @override
  _DashboardDemandeurPageState createState() => _DashboardDemandeurPageState();
}

class _DashboardDemandeurPageState extends State<DashboardDemandeurPage> {
  int _currentIndex = 0;
  final ParcelleService parcelleService = ParcelleService();
  List<Parcelle> parcelles = [];
  TextEditingController searchController = TextEditingController();
  LatLng? searchedLocation;
  String? coutMoyenParcelle;
  String? lieuParcelle;
  String? superficieParcelle;
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    loadParcelles();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
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

  Future<void> loadParcelles() async {
    List<Parcelle> fetchedParcelles = await parcelleService.getAllParcelles();
    setState(() {
      parcelles = fetchedParcelles;
    });
  }

void searchParcelle() async {
    final query = searchController.text;

    // Check if query is empty and reset map view
    if (query.isEmpty) {
      setState(() {
        searchedLocation = null;
        _mapController.move(LatLng(12.6392, -8.0029), 13.0);
        coutMoyenParcelle = '';
        lieuParcelle = '';
        superficieParcelle = '';
      });
      return;
    }

    final foundParcelle = parcelles.firstWhere(
      (parcelle) => parcelle.numParcelleOuTitre.toString() == query,
      orElse: () => Parcelle(
        id: '',
        nomProprietaire: '',
        prenomProprietaire: '',
        addresseProprietaire: '',
        numParcelleOuTitre: 0,
        numEnregFolios: 0,
        superficieTerrain: '',
        lieuParcelle: '',
        planParcelle: '',
        coutMoyenParcelle: '',
        latitude: 0,
        longitude: 0,
        verification: false,
        litige: false,
        historiqueTransactions: [],
      ),
    );

    if (foundParcelle.id.isNotEmpty) {
      setState(() {
        searchedLocation =
            LatLng(foundParcelle.latitude, foundParcelle.longitude);
        coutMoyenParcelle = foundParcelle.coutMoyenParcelle;
        lieuParcelle = foundParcelle.lieuParcelle;
        superficieParcelle = foundParcelle.superficieTerrain;

        // Animate the map movement
        _mapController.move(searchedLocation!, 13.0);
        Future.delayed(Duration(milliseconds: 500), () {
          _mapController.move(searchedLocation!, 15.0); // Slight zoom effect
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parcelle non trouvée.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: couleurprincipale.withOpacity(0.2),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: screenWidth * 0.1,
              height: screenHeight * 0.05,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COUCOU !',
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.03),
                  ),
                  Text(
                    'Abdalla Guindo',
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.05),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,
                color: couleurprincipale.withOpacity(1.0), size: screenWidth * 0.07),
            onPressed: () {
              // Action pour les notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle,
                color: couleurprincipale.withOpacity(1.0), size: screenWidth * 0.07),
            onPressed: () {
              // Action pour accéder au profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: couleurprincipale, size: screenWidth * 0.07),
                  hintText:
                      'Entrer le numéro de parcelle pour voir l\'emplacement',
                  filled: true,
                  fillColor: Colors.transparent, 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: couleurprincipale),
                  ),
                ),
                onSubmitted: (_) => searchParcelle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (coutMoyenParcelle != null &&
                      lieuParcelle != null &&
                      superficieParcelle != null &&
                      coutMoyenParcelle!.isNotEmpty &&
                      lieuParcelle!.isNotEmpty &&
                      superficieParcelle!.isNotEmpty)
                    Card(
                      margin: EdgeInsets.all(8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.monetization_on,
                                    color: Colors.green,
                                    size: screenWidth * 0.06),
                                SizedBox(width: 10),
                                Text(
                                  'Coût moyen : $coutMoyenParcelle',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.red,
                                    size: screenWidth * 0.06),
                                SizedBox(width: 10),
                                Text(
                                  'Lieu : $lieuParcelle',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.square_foot,
                                    color: Colors.blue,
                                    size: screenWidth * 0.06),
                                SizedBox(width: 10),
                                Text(
                                  'Superficie : $superficieParcelle',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    height:
                        isLargeScreen ? screenHeight * 0.5 : screenHeight * 0.3,
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
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: searchedLocation ?? LatLng(12.6392, -8.0029),
                          zoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          if (searchedLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: searchedLocation!,
                                  builder: (ctx) => Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: screenWidth * 0.08,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
