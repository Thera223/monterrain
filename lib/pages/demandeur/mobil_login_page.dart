import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/services/serviceAuthentification/auth_service_mobile.dart';
import 'package:terrain/services/user_service.dart';

class LoginPageMobile extends StatefulWidget {
  @override
  _LoginPageMobileState createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  TabController? _tabController;
  bool _obscureTextLogin = true;
  bool _obscureTextRegister = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _adresseController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceMobile>(context);
    final userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              // Logo
              Image.asset(
                'assets/images/logo.png', // Chemin vers le logo
                height: 120,
              ),
              SizedBox(height: 20),
              // Onglets Connexion/Inscription
              TabBar(
                controller: _tabController,
                labelColor: Colors.purple,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.purple,
                tabs: [
                  Tab(text: 'Connexion'),
                  Tab(text: 'Inscription'),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Connexion
                    _buildLoginForm(authService),
                    // Inscription
                    _buildRegisterForm(authService, userService),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildLoginForm(AuthServiceMobile authService) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureTextLogin ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureTextLogin = !_obscureTextLogin;
                  });
                },
              ),
            ),
            obscureText: _obscureTextLogin,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final user = await authService.signInWithEmail(
                _emailController.text,
                _passwordController.text,
                context,
              );

              if (user != null) {
                // Après connexion, récupérer le rôle depuis Firestore
                final role = await authService.getUserRole(user.uid);

                // Redirection basée sur le rôle
                if (role == 'personnel') {
                  Navigator.pushReplacementNamed(context, '/personnel-mobile');
                } else if (role == 'demandeur') {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  _showErrorDialog(context, 'Rôle inconnu');
                }
              }
            },
            child: Text(
              'connectez-vous',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRegisterForm(
    AuthServiceMobile authService, UserService userService) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nomController,
          decoration: InputDecoration(
            labelText: 'Nom',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _prenomController,
          decoration: InputDecoration(
            labelText: 'Prénom',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _adresseController,
          decoration: InputDecoration(
            labelText: 'Adresse',
            prefixIcon: Icon(Icons.home_outlined),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureTextRegister
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureTextRegister = !_obscureTextRegister;
                });
              },
            ),
          ),
          obscureText: _obscureTextRegister,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            try {
              // Inscription Firebase Auth
              final user = await authService.registerWithEmail(
                _emailController.text,
                _passwordController.text,
                context,
              );
              if (user != null) {
                // Ajouter les informations utilisateur à Firestore
                await userService.addDemandeur(
                  email: _emailController.text,
                  nom: _nomController.text,
                  prenom: _prenomController.text,
                  adresse: _adresseController.text,
                  password: _passwordController.text,
                );
                // Afficher un message de succès
                _showSuccessDialog(context);
              }
            } catch (e) {
              // Afficher un message d'erreur en cas d'échec
              _showErrorDialog(context, e.toString());
            }
          },
          child: Text(
            'inscrivez-vous',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    ),
  );
}

// Fonction pour afficher un message de succès
void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Inscription réussie'),
      content: Text(
          'Votre compte a été créé avec succès. Vous pouvez maintenant vous connecter.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            _tabController?.animateTo(0); // Basculer vers l'onglet connexion
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

// Fonction pour afficher un message d'erreur
void _showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Erreur'),
      content: Text(errorMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}
    }