

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/chefpersonnel/chef_user_page.dart';
import 'package:terrain/pages/chefpersonnel/demandechef.dart';
import 'package:terrain/pages/sidebar.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/services/user_service.dart';


class ChefDashboardPage extends StatefulWidget {
  final String localite;

  ChefDashboardPage({required this.localite});

  @override
  _ChefDashboardPageState createState() => _ChefDashboardPageState();
}

class _ChefDashboardPageState extends State<ChefDashboardPage> {
  int _selectedIndex = 0;
  String? chefId;
  bool isLoading = true;
  int demandesEnAttente = 0;
  int demandesEnCours = 0;
  int demandesTerminees = 0;
  int totalPersonnelAjoute = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final demandeService = Provider.of<DemandeService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      chefId = currentUser.uid;

      try {
        String? chefLocalite = await demandeService.getLocaliteForChef(chefId!);

        if (chefLocalite != null) {
          demandesEnAttente = await demandeService.getDemandesCount(
              localite: chefLocalite, statut: 'En attente');
          demandesEnCours = await demandeService.getDemandesCount(
              localite: chefLocalite, statut: 'En cours');
          demandesTerminees = await demandeService.getDemandesCount(
              localite: chefLocalite, statut: 'Répondu');
        }

        totalPersonnelAjoute = await userService.getPersonnelsCount(chefId!);

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print('Erreur lors du chargement des données du tableau de bord: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return ChefPersonnelDemandesPage(); // Page des demandes
      case 2:
        return PersonnelManagementPage(); // Page de gestion des utilisateurs
      default:
        return _buildDashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavigationSidebarChef(
        selectedIndex: _selectedIndex,
        onItemTapped: _onDrawerItemTapped,
      ),
      appBar: AppBar(
        title: Text('Tableau de bord du Chef de Personnel'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {}),
          CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white)),
          SizedBox(width: 16),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildPageContent(),
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildStatCardsWrap(),
        ],
      ),
    );
  }

  // Utilisation de Wrap pour des cartes compactes de statistiques
  Widget _buildStatCardsWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildStatCard('Demandes en attente', demandesEnAttente.toString(),
            Icons.pending, Colors.orange[100]!),
        _buildStatCard('Demandes en cours', demandesEnCours.toString(),
            Icons.work, Colors.blue[100]!),
        _buildStatCard('Demandes terminées', demandesTerminees.toString(),
            Icons.check_circle, Colors.green[100]!),
        _buildStatCard('Personnel ajouté', totalPersonnelAjoute.toString(),
            Icons.person, Colors.purple[100]!),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String count, IconData icon, Color backgroundColor) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        color: backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black, size: 40),
              SizedBox(height: 4),
              Text(count,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text(title,
                  style: TextStyle(fontSize: 28, color: Colors.grey[700]),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
