import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/screen/Register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widget/custom_elevated_button.dart';
import 'package:renconsport_flutter/widget/custom_input.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Image(
                          image: AssetImage("assets/logo_page_login.png")),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                          label: "Email", controller: _emailController),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                          label: "Mot de passe",
                          controller: _passwordController),
                    ),
                    CustomElevatedButton(
                        hasIcon: false,
                        icon: const Icon(Icons.abc),
                        text: "Se connecter",
                        callback: validateForm),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
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
                                            builder: (context) =>
                                                const Register()));
                                  })
                          ],
                        ),
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
        .post(Uri.parse("$urlApi/login_check"),
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email ou mot de passe incorrect")));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une erreur est survenue")),
      );
    });
  }

  validateForm() {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez remplir les champs")));
    } else {
      logUser();
    }
  }
}
