import 'package:appffn/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/exercices_page.dart';

void main() async {
  // Assure que toutes les dépendances sont initialisées avant de lancer l'application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialisation de Firebase
  runApp(MyApp());  // Lancement de l'application
}

class MyApp extends StatelessWidget {
  // Définition des couleurs utilisées dans le thème
  static const Color primaryColor = Color(0xFF6200EE);  // Couleur principale
  static const Color secondaryColor = Color(0xFF03DAC6); // Couleur secondaire
  static const Color buttonColor = Color(0xFF3700B3); // Couleur des boutons
  static const Color textColor = Colors.white; // Texte en blanc pour un bon contraste

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark, // Mode sombre activé
        primaryColor: primaryColor,  // Définir la couleur principale de l'app
        scaffoldBackgroundColor: Colors.black, // Fond de l'application en noir
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,  // Couleur de la barre d'applications
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),  // Boutons avec coins arrondis
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,  // Couleur de fond des boutons secondaires
            foregroundColor: textColor,  // Couleur du texte sur les boutons
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),  // Coins arrondis des boutons
            ),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),  // Style pour les titres
          bodyLarge: TextStyle(color: textColor, fontSize: 16),  // Style pour le texte normal
          bodyMedium: TextStyle(color: textColor),  // Autre style pour le texte
        ),
      ),
      home: HomePage(),  // Page d'accueil qui est la première page affichée
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Stream pour détecter l'état de connexion de l'utilisateur
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        User? user = snapshot.data;  // Récupération de l'utilisateur courant
        bool isConnected = user != null;  // Vérification de l'état de connexion

        return Scaffold(
          appBar: AppBar(
            title: Text("Accueil FFN", style: TextStyle(fontWeight: FontWeight.bold)),  // Titre de la page
            actions: [
              if (isConnected)  // Affichage du texte de l'email de l'utilisateur connecté
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    user!.email ?? 'Utilisateur',
                    style: TextStyle(color: MyApp.textColor),  // Texte en blanc
                  ),
                ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),  // Espacement général autour des éléments
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Centrage vertical des éléments
                children: [
                  ElevatedButton(
                    onPressed: isConnected ? () async {
                      // Déconnexion de l'utilisateur si connecté
                      await FirebaseAuth.instance.signOut();
                    } : navigateToLogin,  // Si non connecté, navigation vers la page de connexion
                    child: Text(
                      isConnected ? "Se déconnecter" : "Connexion",  // Texte en fonction de l'état de connexion
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),  // Espacement entre les éléments
                  if (!isConnected)  // Si l'utilisateur n'est pas connecté, proposer l'inscription
                    ElevatedButton(
                      onPressed: navigateToSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],  // Fond gris pour le bouton d'inscription
                      ),
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (isConnected)  // Si l'utilisateur est connecté, afficher des informations supplémentaires
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],  // Fond gris pour le container
                            borderRadius: BorderRadius.circular(10),  // Coins arrondis
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 5),  // Ombre pour un effet de profondeur
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Programme du jour",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: MyApp.textColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Pompes à faire aujourd'hui : 50",  // Exemple d'information de programme
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: navigateToExercises,  // Navigation vers la page des exercices
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                          ),
                          icon: Icon(Icons.fitness_center, size: 24),
                          label: Text(
                            "Exercices",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Fonction pour naviguer vers la page de connexion
  Future<void> navigateToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),  // Accéder à la page LoginPage
    );
  }

  // Fonction pour naviguer vers la page d'inscription
  void navigateToSignup() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),  // Accéder à la page SignupPage
    );
  }

  // Fonction pour naviguer vers la page des exercices
  void navigateToExercises() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExercisesPage()),  // Accéder à la page ExercisesPage
    );
  }
}
