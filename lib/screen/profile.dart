import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/modal/sporttype.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:renconsport_flutter/widget/tags.dart';
import 'package:renconsport_flutter/widget/custom_elevated_button.dart';
import 'package:renconsport_flutter/widget/custom_input.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.nav});

  final Function nav;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  String bio = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Stack(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: AdaptiveTheme.of(context).theme.primaryColor,
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      snapshot.data!.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "${snapshot.data!.age}, ${snapshot.data!.city}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Center(
                      child: GestureDetector(
                    onTap: () {
                      // when raised button is pressed
                      // we display showModalBottomSheet
                      showModalBottomSheet<void>(
                        // context and builder are
                        // required properties in this widget
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          // we set up a container inside which
                          // we create center column and display text

                          // Returning SizedBox instead of a Container
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: CustomInput(
                                          label: "Changer votre Bio",
                                          controller: _bioController,
                                          isPassword: false),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                                        child: Center(
                                          child: CustomElevatedButton(
                                            icon: const Icon(null),
                                            text: "Changer ma bio",
                                            callback: () {
                                              // Validate will return true if the form is valid, or false if
                                              // the form is invalid.
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                validateForm(snapshot.data!.id);
                                              }
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      width: 340,
                      child: Column(children: [
                        Center(
                          child: Text(
                            "A propos de moi",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${snapshot.data!.bio}",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                        )
                      ]),
                    ),
                  )),
                  FutureBuilder<List<String>>(
                    future: fetchSports(snapshot.data!),
                    builder: (context, snapshotlist) {
                      if (snapshotlist.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while fetching data.
                      } else if (snapshotlist.hasError) {
                        return Text('Error: ${snapshotlist.error}');
                      } else {
                        return Tags(sports: snapshotlist.data!);
                      }
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      (profileImage(snapshot.data!)),
                    ),
                    radius: 80,
                  ),
                ),
              ],
            ),
          ]);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<User> fetchUser() async {
    try {
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
        return User.fromJson(result);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load User');
      }
    } catch (e) {
      print('Error in fetchUser: $e');
      throw Exception('Failed to load User');
    }
  }

  Future<List<String>> fetchSports(User user) async {
    String? token = await storage.read(key: "token");
    if (token == null) {
      throw Exception("Token not found");
    }
    List<String> fetchSportFutures = [];
    for (var sportType in user.sportTypeList) {
      final response = await http.get(
          Uri.parse("https://renconsport-api.osc-fr1.scalingo.io$sportType"),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final typeSport = SportType.fromJson(result);
        fetchSportFutures.add(typeSport.name);
      } else {
        throw Exception('Failed to load Sport Type');
      }
    }
    // Wait for all requests to complete.
    return fetchSportFutures;
  }

  String profileImage(User user) {
    if (user.avatar != null) {
      return user.avatar;
    } else {
      return "assets/placeholder_avatar.png";
    }
  }

  void validateForm(int id) {
    bool hasError = false;
    // Verifies that no field is empty
    if (_bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs"),
        ),
      );
      hasError = true;
      return;
    }
    if (hasError == false) {
      sendModificationForm(id);
    }
  }

  void sendModificationForm(int id) {
    http
        .patch(
      Uri.parse("$urlApi/users/$id"),
      headers: {
        "Content-Type":
            "application/merge-patch+json", // Update the Content-Type header
      },
      body: json.encode({
        "bio": _bioController.text,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        setState(() {});
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
}
