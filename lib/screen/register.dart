import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/widget/custom_elevated_button.dart';
import 'package:renconsport_flutter/widget/custom_input.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.nav});

  final Function nav;

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
  String latitude = "";
  String longitude = "";
  bool cguChecked = false;
  List _townQueryResults = [];
  bool showTowns = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(
                height: 80,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      widget.nav(5);
                    },
                  ),
                )),
            CustomInput(
                label: "Nom d'utilisateur", controller: _usernameController),
            CustomInput(label: "Email", controller: _emailController),
            CustomInput(
                label: "Confirmation Email",
                controller: _emailConfirmController),
            CustomInput(label: "Mot de passe", controller: _passwordController),
            CustomInput(
                label: "Confirmation mot de passe",
                controller: _passwordConfirmController),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownMenu<String>(
                width: MediaQuery.of(context).size.width - 40,
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
            (showTowns == true)
                ? SizedBox(
                    height: 160,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ListView(
                        shrinkWrap: true,
                        children: (_townQueryResults.isNotEmpty
                            ? _townQueryResults.map((town) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(town),
                                      onTap: () {
                                        setState(() {
                                          _townController.text = town;
                                          showTowns = false;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: ListTile(
                                    title: Text("Aucun résultat"),
                                  ),
                                )
                              ]),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                onChanged: (value) {
                  http
                      .get(Uri.parse(
                          "https://api-adresse.data.gouv.fr/search/?q=$value&type=municipality"))
                      .then((response) {
                    setState(() {
                      if (response.statusCode == 200) {
                        setState(() {
                          showTowns = true;
                        });
                        _townQueryResults = [];
                        var townsJson = jsonDecode(response.body);
                        for (var town in townsJson['features']) {
                          _townQueryResults.add(town['properties']['name']);
                        }
                      } else {
                        _townQueryResults = [];
                        setState(() {
                          showTowns = false;
                        });
                      }
                    });
                  });
                },
                controller: _townController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  labelText: "Ville",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: cguChecked,
                    onChanged: ((value) {
                      setState(() {
                        cguChecked = value!;
                      });
                    })),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      const TextSpan(text: "J'accepte les"),
                      TextSpan(
                          text: " Conditions d'Utilisation",
                          style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            // TODO remplacer le lien vers les CGU
                            ..onTap = () {
                              widget.nav(6);
                            })
                    ],
                  ),
                ),
              ],
            ),
            // TODO: sports pratiqués
            CustomElevatedButton(
                hasIcon: false,
                icon: const Icon(Icons.abc),
                text: "S'enregistrer",
                callback: validateForm)
          ],
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
    // Verifies that the user is at least 13 years old
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
    // Verifies that the gender is selected
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner votre genre"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the town is selected
    if (_townController.text.isEmpty || _townController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner votre ville"),
        ),
      );
      hasError = true;
      return;
    }
    // Verifies that the CGU is checked
    if (cguChecked == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Vous devez accepter les conditions générales d'utilisation"),
        ),
      );
      hasError = true;
      return;
    }
    if (hasError == false) {
      getCoordinates();
      sendForm();
    }
  }

  void sendForm() {
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
              "latitude": latitude,
              "longitude": longitude,
              "bio": "",
            }))
        .then((response) {
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Votre compte a bien été créé"),
          ),
        );
        widget.nav(5);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Une erreur est survenue"),
          ),
        );
      }
    });
  }

  void getCoordinates() {
    http
        .get(Uri.parse(
            "https://api-adresse.data.gouv.fr/search/?q=${_townController.text}&type=municipality&limit=1"))
        .then((response) {
      var townsJson = jsonDecode(response.body);
      var lat =
          townsJson['features'][0]['geometry']['coordinates'][1].toString();
      var lon =
          townsJson['features'][0]['geometry']['coordinates'][0].toString();
      setState(() {
        latitude = lat;
      });
      setState(() {
        longitude = lon;
      });
    });
  }
}
