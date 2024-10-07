import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          '',
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
              SizedBox(height: 20),

              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.purple,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),

              SizedBox(height: 16),

              // Ligne de séparation avec indicateur
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.purple),
                ],
              ),

              SizedBox(height: 30),

              // Champ Nom
              TextFormField(
                initialValue: 'Jean Dupont', // Nom de l'utilisateur
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),

              SizedBox(height: 16),

              // Champ Email
              TextFormField(
                initialValue:
                    'jean.dupont@example.com', // Email de l'utilisateur
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),

              SizedBox(height: 16),

              // Champ Mot de passe
              TextFormField(
                initialValue: '********', // Masquer le mot de passe
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  suffixIcon:
                      Icon(Icons.remove_red_eye_outlined, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),

              SizedBox(height: 16),

              // Champ Téléphone
              TextFormField(
                initialValue: '+33 6 12 34 56 78', // Téléphone de l'utilisateur
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),

              SizedBox(height: 30),

              // Bouton Se déconnecter
              ElevatedButton.icon(
                onPressed: () {
                  // Logique pour se déconnecter
                },
                icon: Icon(Icons.logout, color: Colors.purple),
                label: Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.withOpacity(0.1),
                  foregroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Profil actif
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Demande',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Conseils',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
