import 'package:appffn/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();  // Contrôleur pour l'email
  final _passwordController = TextEditingController();  // Contrôleur pour le mot de passe
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Instance de FirebaseAuth pour l'authentification

  // Fonction pour inscrire l'utilisateur avec l'email et le mot de passe
  Future<void> signUpWithEmailPassword() async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,  // Récupération de l'email de l'utilisateur
        password: _passwordController.text,  // Récupération du mot de passe de l'utilisateur
      );
      print('Utilisateur inscrit : ${userCredential.user}');  // Affichage de l'utilisateur inscrit dans la console
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie !')),  // Message de confirmation d'inscription
      );
      // Redirection vers la page d'accueil après inscription réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Remplace la page actuelle par la page d'accueil
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      // Gestion des erreurs spécifiques liées à l'inscription
      if (e.code == 'weak-password') {
        errorMessage = 'Le mot de passe est trop faible.';  // Mot de passe trop faible
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Cet email est déjà utilisé par un autre compte.';  // Email déjà utilisé
      } else {
        errorMessage = 'Erreur inconnue : ${e.message}';  // Autres erreurs inconnues
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),  // Affichage du message d'erreur
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("S'inscrire")),  // Titre de la page d'inscription
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Espacement autour des éléments
        child: Column(
          children: [
            // Champ de texte pour l'email
            TextField(
              controller: _emailController,  // Associe le champ de texte au contrôleur de l'email
              decoration: InputDecoration(labelText: 'Email'),  // Libellé du champ
            ),
            // Champ de texte pour le mot de passe
            TextField(
              controller: _passwordController,  // Associe le champ de texte au contrôleur du mot de passe
              obscureText: true,  // Masque le mot de passe
              decoration: InputDecoration(labelText: 'Mot de passe'),  // Libellé du champ
            ),
            SizedBox(height: 20),  // Espacement entre les éléments
            // Bouton d'inscription
            ElevatedButton(
              onPressed: signUpWithEmailPassword,  // Appel de la fonction d'inscription
              child: Text("S'inscrire"),  // Texte du bouton
            ),
          ],
        ),
      ),
    );
  }
}
