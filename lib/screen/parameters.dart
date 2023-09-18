import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/screen/login.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key});

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Center(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Paramètres du compte',
                style: TextStyle(
                    color: Color(0xFFFAFAFA),
                    fontSize: 26,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          tileColor: AdaptiveTheme.of(context).theme.cardColor,
        ),
        ListTile(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Modifier mes informations',
                style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        ListTile(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Désactiver mon compte',
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
            ),
          ),
        ),
        ListTile(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Options de confidentialité',
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
            ),
          ),
        ),
        ListTile(
          title: const Center(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                "Paramètres de l'appli",
                style: TextStyle(
                    color: Color(0xFFFAFAFA),
                    fontSize: 26,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          tileColor: AdaptiveTheme.of(context).theme.cardColor,
        ),
        ListTile(
          title: Center(
            child: GestureDetector(
              onTap: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Thème actuel : ',
                    style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
                  ),
                  Text(
                      AdaptiveTheme.of(context).mode.isDark
                          ? 'Sombre'
                          : AdaptiveTheme.of(context).mode.isLight
                              ? 'Clair'
                              : 'Systeme',
                      style:
                          AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
        ListTile(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Conditions générales',
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
            ),
          ),
        ),
        ListTile(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Politique de confidentialité',
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
            ),
          ),
        ),
        ListTile(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('A propos',
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.20,
                vertical: MediaQuery.of(context).size.width * 0.05),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double?>(5),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      AdaptiveTheme.of(context).theme.primaryColor),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(20))),
              onPressed: () {
                storage.delete(key: "token");
                redirect();
              },
              icon: const Icon(Icons.logout, color: Colors.white, size: 30),
              label: const Text(
                "Déconnexion",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
      ],
    );
  }

  void redirect() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }
}
