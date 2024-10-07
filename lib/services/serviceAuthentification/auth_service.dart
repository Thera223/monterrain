import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:terrain/services/serviceAuthentification/auth_service_mobile.dart';

abstract class AuthServiceInterface extends PlatformInterface
    with ChangeNotifier {
  AuthServiceInterface() : super(token: _token);

  static final Object _token = Object();

  static AuthServiceInterface _instance =
      AuthServiceMobile() as AuthServiceInterface; // Instanciation par défaut mobile

  static AuthServiceInterface get instance => _instance;

  static set instance(AuthServiceInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Méthodes communes d'authentification
  Future<User?> signInWithEmail(
      String email, String password, BuildContext context);
  Future<void> signOut();

  // Inscription uniquement pour le mobile
  Future<void> registerWithEmail(
      String email, String password, BuildContext context) {
    throw UnimplementedError(
        "L'inscription n'est pas disponible sur cette plateforme.");
  }

  Future<void> initializeAdminAccount(); // Web seulement
}
