import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/services/serviceAuthentification/auth_service_web.dart';

class LoginPageWeb extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceWeb>(context);

    return Scaffold(
      body: Row(
        children: [
          Image.asset(
            'assets/images/logo.png', // Assurez-vous que l'image existe
            width: 40,
            height: 40,
          ),
          // Left side: Image and illustration
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  'assets/images/login.png', // Image file path
                  height: 400, // Adjust the height as needed
                ),
              ),
            ),
          ),

          // Right side: Login form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  width: 400, // Adjust the width
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App title with rocket emoji
                      Text(
                        'Back-office Administration🚀',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'connecter-vous',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 32),

                      // Email input
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'sy@hotmail.com',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Password input
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          hintText: 'Entrer le mot de passe',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 32),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await authService.signInWithEmail(
                              emailController.text,
                              passwordController.text,
                              context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors
                                .deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ), // Purple color for the button
                          ),
                          child: Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
