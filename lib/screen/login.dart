import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:renconsport_flutter/widget/custom_elevated_button.dart';
import 'package:renconsport_flutter/widget/custom_input.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.nav});
  final Function(int index) nav;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
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
                vertical: MediaQuery.of(context).size.height * 0.1),
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Image(
                        image: AssetImage("assets/logo_page_login.png")),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                          label: "Email",
                          controller: _emailController,
                          isPassword: false),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomInput(
                        label: "Mot de passe",
                        controller: _passwordController,
                        isPassword: true,
                      ),
                    ),
                    CustomElevatedButton(
                        icon: const Icon(null),
                        text: "Se connecter",
                        callback: validateForm),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: RichText(
                        text: TextSpan(
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .bodySmall,
                          children: <TextSpan>[
                            const TextSpan(text: "Pas de compte ? "),
                            TextSpan(
                                text: "S'inscrire",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    widget.nav(6);
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
        storage.write(key: 'token', value: token);
        widget.nav(0);
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

  void validateForm() {
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
