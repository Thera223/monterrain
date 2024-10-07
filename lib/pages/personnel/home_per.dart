import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:terrain/model/parcelle_model.dart';
import 'package:terrain/services/parcelle_service.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/model/demande.dart';

class HomePersonnelPage extends StatefulWidget {
  @override
  _HomePersonnelPageState createState() => _HomePersonnelPageState();
}

class _HomePersonnelPageState extends State<HomePersonnelPage> {
  int _currentIndex = 0;
  final ParcelleService parcelleService = ParcelleService();
  final DemandeService demandeService = DemandeService();
  List<Parcelle> parcelles = [];
  TextEditingController searchController = TextEditingController();
  LatLng? searchedLocation;
  MapController _mapController = MapController();
  Demande? selectedDemande; // Demande sélectionnée

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
        break; // Déjà sur l'accueil
      case 1:
        Navigator.pushNamed(context, '/personnel-demandes');
        break;
      case 2:
        Navigator.pushNamed(context, '/personnel-profil');
        break;
    }
  }

  Future<void> loadParcelles() async {
    List<Parcelle> fetchedParcelles = await parcelleService.getAllParcelles();
    setState(() {
      parcelles = fetchedParcelles;
    });
  }

  // Recherche de la parcelle par numéro et récupération de la demande associée
  void searchParcelle() async {
    final query = searchController.text;

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
        _mapController.move(searchedLocation!, 15.0);
      });

      // Rechercher la demande associée à cette parcelle
      List<Demande> demandes =
          await demandeService.getDemandesByParcelle(query);
      if (demandes.isNotEmpty) {
        setState(() {
          selectedDemande = demandes.first;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Aucune demande trouvée pour cette parcelle.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parcelle non trouvée.')),
      );
    }
  }

  // Méthode pour soumettre la réponse
  void soumettreReponse(String reponse) async {
    if (selectedDemande != null) {
      await demandeService.repondreDemande(selectedDemande!.id, reponse);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Réponse soumise avec succès.')),
      );
      setState(() {
        selectedDemande = null; // Réinitialiser la demande une fois traitée
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                    'Bonjour !',
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.03),
                  ),
                  Text(
                    'Personnel Name',
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.05),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Barre de recherche pour le numéro de parcelle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: Colors.purple, size: screenWidth * 0.07),
                  hintText:
                      'Entrer le numéro de parcelle pour voir l\'emplacement',
                  filled: true,
                  fillColor: Colors.purple[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => searchParcelle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Carte interactive
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
                  if (selectedDemande != null) ...[
                    SizedBox(height: 20),
                    Text(
                        'Demande : ${selectedDemande!.typesDemande?.join(", ") ?? "Inconnue"}'),
                    Text(
                        'Propriétaire : ${selectedDemande!.nomProprietaire ?? "Inconnu"}'),
                    SizedBox(height: 10),
                    Text('Réponse à fournir :'),
                    TextField(
                      onSubmitted: (value) {
                        soumettreReponse(value); // Soumettre la réponse
                      },
                      decoration: InputDecoration(
                        hintText: 'Entrez la réponse ici',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _currentIndex == 0 ? Colors.purple : Colors.grey,
                size: screenWidth * 0.07),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment,
                color: _currentIndex == 1 ? Colors.purple : Colors.grey,
                size: screenWidth * 0.07),
            label: 'Demandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _currentIndex == 2 ? Colors.purple : Colors.grey,
                size: screenWidth * 0.07),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
