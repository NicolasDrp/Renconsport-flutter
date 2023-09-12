import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/screen/Register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: MediaQuery.of(context).size.height * 0.05),
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        image: AssetImage("assets/logo_page_login.png")),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Merci de renseigner votre email";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Merci de renseigner votre mot de passe";
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logUser();
                          }
                        },
                        child: const Text("Se connecter")),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(text: "Pas de compte ?"),
                          TextSpan(
                              text: " S'inscrire",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void logUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    http
        .post(Uri.parse("http://192.168.43.181:8000/api/login_check"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(<String, String>{
              'email': email,
              'password': password,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        String token = json.decode(response.body)['token'];
        widget.storage.write(key: 'token', value: token);
        Navigator.pushReplacementNamed(context, '/');
      } else {
        //TODO: afficher un message d'erreur
        print("Erreur d'authentification");
      }
    }).catchError((error) {
      print(error);
    });
    ;
  }
}
