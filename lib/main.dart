import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:terrain/pages/admin/admindemande.dart';
import 'package:terrain/pages/chefpersonnel/chef_user_page.dart';
import 'package:terrain/pages/chefpersonnel/demandechef.dart';

// Import des pages
import 'package:terrain/pages/demandeur/dmobdemande.dart'; // Dashboard des demandes mobile
import 'package:terrain/pages/demandeur/form_demandeur.dart'; // Soumission demande
import 'package:terrain/pages/demandeur/home_page.dart'; // Page d'accueil
import 'package:terrain/pages/demandeur/inscriptiondemandeur.dart'; // Page d'inscription
import 'package:terrain/pages/demandeur/mob_conseill.dart'; // Conseils page mobile
import 'package:terrain/pages/demandeur/mob_profil.dart'; // Profil page mobile
import 'package:terrain/pages/admin/dashboard_page.dart'; // Dashboard Admin web
import 'package:terrain/pages/chefpersonnel/tableau_chef.dart'; // Dashboard chef de personnel
import 'package:terrain/pages/demandeur/mobil_login_page.dart';
import 'package:terrain/pages/fictive.dart';
import 'package:terrain/pages/historique.dart';
import 'package:terrain/pages/personnel/demande_pers.dart';
import 'package:terrain/pages/personnel/home_per.dart';
import 'package:terrain/pages/personnel/profil.dart';
import 'package:terrain/pages/web_login_page.dart';
import 'package:terrain/services/demande_ser.dart';
import 'package:terrain/services/dem_conseil_serv.dart'; // Service Conseil
import 'package:terrain/services/hist_service.dart';
import 'package:terrain/services/parcelle_service.dart';
import 'package:terrain/services/serviceAuthentification/auth_service_mobile.dart'; // Authentification mobile
import 'package:terrain/services/serviceAuthentification/auth_service_web.dart'; // Authentification web
import 'package:terrain/services/assistantjuriduque_service.dart'; // Service assistant juridique
import 'package:terrain/services/user_service.dart'; // Service utilisateur
import 'firebase_options.dart'; // Options Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // peuplerBaseDeDonnees();

  AuthServiceWeb authServiceWeb = AuthServiceWeb();
  await authServiceWeb.initializeAdminAccount();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (Theme.of(context).platform == TargetPlatform.iOS ||
            Theme.of(context).platform == TargetPlatform.android)
          ChangeNotifierProvider<AuthServiceMobile>(
            create: (_) => AuthServiceMobile(),
          )
        else
          ChangeNotifierProvider<AuthServiceWeb>(
            create: (_) => AuthServiceWeb(),
          ),
        ChangeNotifierProvider<UserService>(
          create: (_) => UserService(),
        ),
        ChangeNotifierProvider<ParcelleService>(
          create: (_) => ParcelleService(),
        ),
        ChangeNotifierProvider<AssistantService>(
          create: (_) => AssistantService(),
        ),
        ChangeNotifierProvider<ConseilService>(
          create: (_) => ConseilService(),
        ),
        ChangeNotifierProvider<DemandeService>(
          create: (_) => DemandeService(),
        ),
        ChangeNotifierProvider<LogService>(
          create: (_) => LogService(),
        ),
      ],
      child: MaterialApp(
        title: 'Gestion de Parcelles',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/', // Point d'entrée de l'application
        routes: {
          '/': (context) => HomePage(), // Page d'accueil pour démarrer
          '/dashboard': (context) => DashboardDemandeurPage(), // Demandeur
          '/personnel-mobile': (context) => HomePersonnelPage(),
          '/personnel-demandes': (context) => PersonnelDemandesPage(),
          '/personnel-profil': (context) => PersonnelProfilePage(),
          '/submit-demande': (context) => SoumissionDemandePage(),
          '/conseils': (context) => ConseilsPage(),
          '/profil': (context) => ProfilePage(),
          // '/register': (context) => RegisterPage(),
          '/demandes': (context) => DemandePage(),
          '/logs': (context) => LogsPage(),
          '/admin-dashboard': (context) =>
              DashboardPage(role: 'admin'), // Admin

          '/chef-dashboard': (context) =>
              ChefDashboardPage(localite: ''), // Chef de personnel
          '/personnel-dashboard': (context) => PersonnelManagementPage(),
          // Personnel
          '/admin-demandes': (context) =>
              AdminDemandesPage(), // Page pour l'admin
          '/chef-personnel-demandes': (context) =>
              ChefPersonnelDemandesPage(), // Page pour le chef de personnel
        },
        onGenerateRoute: _onGenerateRoute, // Pour gérer les routes dynamiques
      ),
    );
  }

  // Gestion des routes dynamiques en fonction du rôle de l'utilisateur
  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/admin-dashboard':
        return MaterialPageRoute(
            builder: (context) => DashboardPage(role: 'admin'));
      case '/chef-dashboard':
        String localite = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ChefDashboardPage(localite: localite));
      case '/personnel-dashboard':
        // ignore: unused_local_variable
        String chefId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => PersonnelManagementPage());
      default:
        return MaterialPageRoute(builder: (context) => HomePage());
    }
  }
}

// Page d'accueil qui détecte la plateforme et redirige vers la bonne page de connexion
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Détecter la plateforme et rediriger vers la bonne page de connexion
    if (Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android) {
      return LoginPageMobile(); // Page mobile
    } else {
      return LoginPageWeb(); // Page web
    }
  }
}

// Page de connexion pour les utilisateurs mobiles
// class LoginPageMobile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connexion Mobile'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/dashboard');
//           },
//           child: Text('Se connecter (Mobile)'),
//         ),
//       ),
//     );
//   }
// }

// Page de connexion pour les administrateurs (web)
// class AdminLoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connexion Admin Web'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/admin-dashboard');
//           },
//           child: Text('Se connecter (Web)'),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:provider/provider.dart';
// // import 'package:terrain/pages/inscriptiondemandeur.dart';
// //  // Page de login pour le web
// // import 'package:terrain/pages/mobil_login_page.dart';

// // import 'package:terrain/pages/dashboard_page.dart';
// // import 'package:terrain/pages/web_login_page.dart';
// // import 'package:terrain/services/assistantjuriduque_service.dart';
// // import 'package:terrain/services/serviceAuthentification/auth_service_mobile.dart';
// // import 'package:terrain/services/serviceAuthentification/auth_service_web.dart';
// // import 'package:terrain/services/user_service.dart';
// // import 'firebase_options.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// //   );

// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MultiProvider(
// //       providers: [
// //         // Utilisation du service spécifique à chaque plateforme
// //         if (Theme.of(context).platform == TargetPlatform.iOS ||
// //             Theme.of(context).platform == TargetPlatform.android)
// //           ChangeNotifierProvider(create: (_) => AuthServiceMobile())
// //         else
// //           ChangeNotifierProvider(create: (_) => AuthServiceWeb()),

// //         ChangeNotifierProvider(create: (_) => UserService()), // Service User
// //         ChangeNotifierProvider(create: (_) => AssistantService()),
// //       ],
// //       child: MaterialApp(
// //         title: 'Gestion de Parcelles',
// //         theme: ThemeData(primarySwatch: Colors.blue),
// //         initialRoute: '/',
// //         routes: {
// //           // Pages spécifiques au mobile et au web
// //           '/': (context) {
// //             if (Theme.of(context).platform == TargetPlatform.iOS ||
// //                 Theme.of(context).platform == TargetPlatform.android) {
// //               return LoginPageMobile(); // Page mobile
// //             } else {
// //               return AdminLoginPage(); // Page web
// //             }
// //           },
// //           '/dashboard': (context) => DashboardPage(),
// //           '/register': (context) => RegisterPage(), // Page d'inscription mobile
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'package:terrain/pages/dmobdemande.dart';
// import 'package:terrain/pages/form_demandeur.dart';

// import 'package:terrain/pages/home_page.dart';
// import 'package:terrain/pages/inscriptiondemandeur.dart';
// import 'package:terrain/pages/mob_conseill.dart';
// import 'package:terrain/pages/mob_profil.dart';
// import 'package:terrain/pages/mobil_login_page.dart';
// import 'package:terrain/services/dem_conseil_serv.dart';
// import 'package:terrain/services/serviceAuthentification/auth_service_mobile.dart';
// import 'package:terrain/services/user_service.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Services d'authentification et utilisateur
//         ChangeNotifierProvider<AuthServiceMobile>(
//           create: (_) => AuthServiceMobile(),
//         ),
//         ChangeNotifierProvider<UserService>(
//           create: (_) => UserService(),
//         ),
//          ChangeNotifierProvider<ConseilService>(
//           create: (_) => ConseilService(),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Gestion de Parcelles',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         initialRoute: '/', // Point d'entrée de l'application
//         routes: {
//           // Page d'accueil / connexion pour le demandeur
//           '/': (context) => LoginPageMobile(),

//           // Dashboard du demandeur
//           '/dashboard': (context) => DashboardDemandeurPage(),

//           // Formulaire pour soumettre une demande
//           '/submit-demande': (context) => SoumissionDemandePage(),

//           // Page des conseils
//           '/conseils': (context) => ConseilsPage(),

//           // Page de gestion de profil
//           '/profil': (context) => ProfilePage(),

//           // Inscription pour les nouveaux utilisateurs
//           '/register': (context) => RegisterPage(),

//           '/demandes': (context) => DemandePage(),

//         },
//       ),
//     );
//   }
// }
