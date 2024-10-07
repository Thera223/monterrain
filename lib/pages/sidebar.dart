import 'package:flutter/material.dart';

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
                isSelectedColor: Colors.purple, // Coloration pour cet item
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
            onItemTapped: onItemTapped,
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
