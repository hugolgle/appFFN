import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simule une connexion réussie
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value!.isEmpty ? "Entrez votre email" : null,
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? "Entrez votre mot de passe" : null,
                onSaved: (value) => password = value!,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: handleLogin,
                child: Text("Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
