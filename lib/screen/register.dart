import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/widget/custom_elevated_button.dart';
import 'package:renconsport_flutter/widget/custom_input.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailConfirmController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          elevation: 0,
          backgroundColor: Colors.white,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              CustomInput(
                  label: "Nom d'utilisateur", controller: _usernameController),
              CustomInput(label: "Email", controller: _emailController),
              CustomInput(
                  label: "Confirmation Email",
                  controller: _emailConfirmController),
              CustomInput(
                  label: "Mot de passe", controller: _passwordController),
              CustomInput(
                  label: "Confirmation mot de passe",
                  controller: _passwordConfirmController),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange))),
                  controller: _genderController,
                  label: const Text("Genre"),
                  dropdownMenuEntries: ["Homme", "Femme", "Autre"]
                      .map((gender) => DropdownMenuEntry(
                            value: gender,
                            label: gender,
                          ))
                      .toList(),
                  onSelected: (String? gender) {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                ),
              ),
              CustomInput(label: "Age", controller: _ageController),
              CustomInput(label: "Ville", controller: _townController),
              //TODO la checklist des cgu
              CustomElevatedButton(
                  hasIcon: false,
                  icon: const Icon(Icons.abc),
                  text: "S'enregistrer",
                  callback: validateForm)
            ],
          ),
        ),
      ),
    );
  }

  validateForm() {
    bool hasError = false;
    // Verifies that no field is empty
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _emailConfirmController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty ||
        selectedGender == null ||
        _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the passwords are the same
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les mots de passe ne correspondent pas"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the emails are the same
    if (_emailController.text != _emailConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les emails ne correspondent pas"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the mail is valid
    if (!_emailController.text.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("L'email n'est pas valide"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the passwords are at least 8 characters long
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Le mot de passe doit contenir au moins 8 caractères"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the password contains at least one number and one uppercase letter
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Le mot de passe doit contenir au moins une majuscule et un chiffre"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the use is at least 13 years old
    if (int.parse(_ageController.text) < 13) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Vous devez être agé d'au moins 13 ans pour vous inscrire sur l'application"),
        ),
      );
      hasError = true;
      return;
    }
    if (hasError == false) {
      sendForm();
    }
  }

  void sendForm() {
    print("sending");
    //TODO: fix le parse de l'age
    http
        .post(Uri.parse("$urlApi/users"),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: json.encode({
              "username": _usernameController.text,
              "email": _emailController.text,
              "password": _passwordController.text,
              "age": int.parse(_ageController.text),
              "city": _townController.text,
              "gender": selectedGender,
              "latitude": "0",
              "longitude": "0",
              "bio": "",
            }))
        .then((response) {
      if (response.statusCode == 201) {
        print("success");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Votre compte a bien été créé"),
          ),
        );
        Navigator.pop(context);
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Une erreur est survenue"),
          ),
        );
      }
    });
  }
}
