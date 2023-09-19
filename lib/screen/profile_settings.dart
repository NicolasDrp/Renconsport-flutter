import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:renconsport_flutter/widget/custom_elevated_button.dart';
import 'package:renconsport_flutter/widget/custom_input.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailConfirmController = TextEditingController();
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
  bool cguChecked = false;
  List _townQueryResults = [];
  bool showTowns = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: _futureBuilderKey,
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // return Text(snapshot.data!.email);
          // changeValue(snapshot.data);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  CustomInput(
                      label: "Nom d'utilisateur",
                      controller: _usernameController),
                  CustomInput(label: "Email", controller: _emailController),
                  CustomInput(
                      label: "Confirmation Email",
                      controller: _emailConfirmController),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
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
                                _townQueryResults
                                    .add(town['properties']['name']);
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
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  changeValue(data) {
    //change value
    _usernameController.text = data.username;
    _emailController.text = data.email;
    _emailConfirmController.text = data.email;
    selectedGender = data.gender;
    _genderController.text = data.gender;
    _ageController.text = data.age.toString();
    _townController.text = data.city;
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

  validateForm() {
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
      sendForm();
    }
  }

  void sendForm() {
    http
        .put(Uri.parse("$urlApi/users/6"),
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
      setState(() {
        latitude = lat;
      });
      setState(() {
        longitude = lon;
      });
    });
  }
}
