import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/exercices_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Point d'entrée
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blueAccent,
          secondary: Colors.orange,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue, // Couleur de fond des boutons
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // Page d'accueil
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isConnected = false;
  int pompesDuJour = 50; // Nombre de pompes à faire aujourd'hui

  // Navigation vers la page de connexion
  void navigateToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );

    if (result == true) {
      setState(() {
        isConnected = true;
      });
    }
  }

  // Déconnexion
  void logout() {
    setState(() {
      isConnected = false;
    });
  }

  // Navigation vers la page des exercices
  void navigateToExercises() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExercisesPage()),
    );
    // On s'assure que l'état est mis à jour au retour des exercices
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil FFN", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isConnected ? logout : navigateToLogin,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 5,
                  backgroundColor: isConnected ? Colors.red : Colors.blueAccent, // Remplacer primary par backgroundColor
                ),
                child: Text(
                  isConnected ? "Se déconnecter" : "Connexion",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              if (isConnected)
              // Affichage du programme du jour (pompes)
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 5),
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
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Pompes à faire aujourd'hui : $pompesDuJour",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: navigateToExercises,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.orange, // Remplacer primary par backgroundColor
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
  }
}
