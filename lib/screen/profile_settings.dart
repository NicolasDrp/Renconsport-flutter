//TODO: Change hard coded ID in api calls

import 'dart:convert';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:renconsport_flutter/widget/city_input.dart';
import 'package:renconsport_flutter/widget/custom_elevated_button.dart';
import 'package:renconsport_flutter/widget/custom_input.dart';
import 'package:renconsport_flutter/widget/custom_back_button.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key, required this.nav});

  final Function nav;

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailConfirmController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Key _futureBuilderKey = UniqueKey();
  String? selectedGender;
  String latitude = "";
  String longitude = "";
  String databasePassword = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: _futureBuilderKey,
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomBackButton(nav: widget.nav, index: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Modifications des informations",
                      style:
                          AdaptiveTheme.of(context).theme.textTheme.bodyLarge,
                    ),
                  ),
                  CustomInput(
                      label: "Nom d'utilisateur",
                      controller: _usernameController,
                      isPassword: false),
                  CustomInput(
                      label: "Email",
                      controller: _emailController,
                      isPassword: false),
                  CustomInput(
                      label: "Confirmation Email",
                      controller: _emailConfirmController,
                      isPassword: false),
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
                        selectedGender = gender;
                      },
                    ),
                  ),
                  CustomInput(
                      label: "Age",
                      controller: _ageController,
                      isPassword: false),
                  CityInput(label: "Ville", controller: _townController),
                  CustomElevatedButton(
                      icon: const Icon(null),
                      text: "Modifier informations",
                      callback: validateModificationForm),

                  //TODO: implement password change

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //   child: Text(
                  //     "Modification du mot de passe",
                  //     style:
                  //         AdaptiveTheme.of(context).theme.textTheme.bodyLarge,
                  //   ),
                  // ),
                  // CustomInput(
                  //     label: "Ancien mot de passe",
                  //     controller: _oldPasswordController,
                  //     isPassword: true),
                  // CustomInput(
                  //     label: "Nouveau mot de passe",
                  //     controller: _passwordController,
                  //     isPassword: true),
                  // CustomInput(
                  //     label: "Confirmation nouveau mot de passe",
                  //     controller: _passwordConfirmController,
                  //     isPassword: true),
                  // CustomElevatedButton(
                  //     icon: const Icon(null),
                  //     text: "Modifier mot de passe",
                  //     callback: validateModificationForm),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  void changeValue(data) {
    //change value
    _usernameController.text = data.username;
    _emailController.text = data.email;
    _emailConfirmController.text = data.email;
    selectedGender = data.gender;
    _genderController.text = data.gender;
    _ageController.text = data.age.toString();
    _townController.text = data.city;
    databasePassword = data.password;
  }

  Future<User> fetchUser() async {
    String? token = await storage.read(key: "token");
    if (token == null) {
      throw Exception(
          ("Token not found")); // Gérer le cas où le token n'est pas disponible
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final response = await http
        .get(Uri.parse("$urlApi/users/${decodedToken['id']}"), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final result = jsonDecode(response.body);
      changeValue(User.fromJson(result));
      return User.fromJson(result);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load User');
    }
  }

  void validateModificationForm() {
    bool hasError = false;
    // Verifies that no field is empty
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _emailConfirmController.text.isEmpty ||
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
    if (hasError == false) {
      getCoordinates();
      sendModificationForm();
    }
  }

  Future<void> sendModificationForm() async {
    String? idUser = await storage.read(key: "id");
    if (idUser == null) {
      throw Exception(
          ("Id not found")); // Gérer le cas où le token n'est pas disponible
    }
    http
        .put(Uri.parse("$urlApi/users/$idUser"),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: json.encode({
              "username": _usernameController.text,
              "email": _emailController.text,
              "age": int.parse(_ageController.text),
              "city": _townController.text,
              "gender": selectedGender,
              "latitude": latitude,
              "longitude": longitude,
              //TODO: Fetch the bio to not erase it
              "bio": "",
            }))
        .then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Votre compte a bien été modifié"),
          ),
        );
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
      latitude = lat;
      longitude = lon;
    });
  }

  void validatePasswordForm() {
    bool hasError = false;
    if (_oldPasswordController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs"),
        ),
      );
      hasError = true;
      return;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les mots de passe ne correspondent pas"),
        ),
      );
      hasError = true;
      return;
    }
    if (hasError == false) {
      sendPasswordForm();
    }
  }

  Future<void> sendPasswordForm() async {
    String? id = await storage.read(key: "id");
    if (id == null) {
      throw Exception(
          ("Token not found")); // Gérer le cas où le token n'est pas disponible
    }
    http
        .patch(Uri.parse("$urlApi/users/$id"),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: json.encode({"password": _passwordController.text}))
        .then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Votre Mot de passe a bien été modifié"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Une erreur est survenue"),
          ),
        );
      }
    });
  }
}
