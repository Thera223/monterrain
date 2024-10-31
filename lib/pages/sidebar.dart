import 'package:firebase_auth/firebase_auth.dart'; // Assurez-vous d'importer FirebaseAuth
import 'package:flutter/material.dart';
import 'package:terrain/pages/config_charte_coul.dart';

class CustomNavigationSidebar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CustomNavigationSidebar({
    required this.onItemTapped,
    required this.selectedIndex, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Largeur de la barre de navigation fixe
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo en haut
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/logo.png', // Chemin vers votre logo
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(height: 20),

              // Les éléments du sidebar
              _buildNavItem(
                title: 'Dashboard',
                icon: Icons.dashboard,
                index: 0,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
              _buildNavItem(
                title: 'Utilisateurs',
                icon: Icons.person,
                index: 1,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
              _buildNavItem(
                title: 'Demandes',
                icon: Icons.assignment,
                index: 2,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
              _buildNavItem(
                title: 'Conseils',
                icon: Icons.support_agent,
                index: 3,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
                isSelectedColor: couleurprincipale, // Coloration pour cet item
              ),
              _buildNavItem(
                title: 'Historique',
                icon: Icons.history,
                index: 4,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
              _buildNavItem(
                title: 'Parcelle',
                icon: Icons.map,
                index: 5,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
            ],
          ),

          // Bouton de déconnexion en bas
          _buildNavItem(
            title: 'Déconnexion',
            icon: Icons.logout,
            index: 6,
            onItemTapped: (index) async {
              if (index == 6) {
                // Appelle la méthode de déconnexion de Firebase
                await FirebaseAuth.instance.signOut();
                // Redirige vers la page de connexion après déconnexion
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            selectedIndex: selectedIndex,
            isLogout: true, // Coloration rouge pour déconnexion
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String title,
    required IconData icon,
    required int index,
    required Function(int) onItemTapped,
    required int selectedIndex,
    Color isSelectedColor = Colors.blue, // Default color
    bool isLogout = false, // Logout option
  }) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        color: selectedIndex == index ? Colors.grey[200] : Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              color: isLogout
                  ? Colors.red
                  : (selectedIndex == index ? isSelectedColor : Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isLogout
                    ? Colors.red
                    : (selectedIndex == index ? isSelectedColor : Colors.grey),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}



class CustomNavigationSidebarChef extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CustomNavigationSidebarChef({
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo en haut
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(height: 20),

              // Les éléments du sidebar pour le chef de personnel
              _buildNavItem(
                title: 'Dashboard',
                icon: Icons.dashboard,
                index: 0,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
              _buildNavItem(
                title: 'Demandes',
                icon: Icons.assignment,
                index: 1,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
              _buildNavItem(
                title: 'Utilisateurs',
                icon: Icons.group,
                index: 2,
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex,
              ),
            ],
          ),

          // Bouton de déconnexion en bas
          _buildNavItem(
            title: 'Déconnexion',
            icon: Icons.logout,
            index: 3,
            onItemTapped: (index) async {
              if (index == 3) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            selectedIndex: selectedIndex,
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String title,
    required IconData icon,
    required int index,
    required Function(int) onItemTapped,
    required int selectedIndex,
    Color isSelectedColor = Colors.blue, // Couleur par défaut pour sélection
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        color: selectedIndex == index ? Colors.grey[200] : Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              color: isLogout
                  ? Colors.red
                  : (selectedIndex == index ? isSelectedColor : Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isLogout
                    ? Colors.red
                    : (selectedIndex == index ? isSelectedColor : Colors.grey),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
