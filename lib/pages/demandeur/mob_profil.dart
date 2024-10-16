import 'package:flutter/material.dart';
import 'package:terrain/pages/config_charte_coul.dart';
import 'package:terrain/widgets/contenudahchef.dart';
// Chemin vers la barre de navigation personnalisée

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 3; // Profil est actif

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Mon Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Avatar avec animation
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width > 600 ? 60 : 40,
                  backgroundColor: couleurprincipale,
                  child: Icon(Icons.person,
                      size: MediaQuery.of(context).size.width > 600 ? 60 : 40,
                      color: Colors.white),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Ligne de séparation avec indicateur animé
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width * 0.2,
                height: 8,
                decoration: BoxDecoration(
                  color: couleurprincipale,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Champ Nom
              _buildProfileField('Nom', 'Jean Dupont', Icons.person_outline,
                  MediaQuery.of(context).size.width),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Champ Email
              _buildProfileField('E-mail', 'jean.dupont@example.com',
                  Icons.email_outlined, MediaQuery.of(context).size.width),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Champ Mot de passe avec option de visibilité
              _buildPasswordField('Mot de passe', '********',
                  MediaQuery.of(context).size.width),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Champ Téléphone
              _buildProfileField('Téléphone', '+33 6 12 34 56 78',
                  Icons.phone_outlined, MediaQuery.of(context).size.width),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // Bouton Se déconnecter avec animation
              ElevatedButton.icon(
                onPressed: () {
                  // Logique pour se déconnecter
                },
                icon: Icon(Icons.logout, color: couleurprincipale),
                label: Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: couleurprincipale.withOpacity(0.1),
                  foregroundColor: couleurprincipale,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                      vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),

      // Barre de navigation inférieure personnalisée
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/demandes');
              break;
            case 2:
              Navigator.pushNamed(context, '/conseils');
              break;
            case 3:
              break; // Déjà sur la page Profil
          }
        },
      ),
    );
  }

  // Fonction utilitaire pour construire un champ de profil
  Widget _buildProfileField(
      String label, String value, IconData icon, double screenWidth) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // Fonction utilitaire pour construire un champ mot de passe
  Widget _buildPasswordField(String label, String value, double screenWidth) {
    return TextFormField(
      initialValue: value,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon:
            Icon(Icons.remove_red_eye_outlined, color: couleurprincipale),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
