import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key, required this.storage, this.savedThemeMode});

  final FlutterSecureStorage storage;
  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(tutorial: ""),
      bottomNavigationBar: const BottomAppBarWidget(),
      body: ListView(
        children: [
          ListTile(
            title: const Center(
              child: Text(
                'Paramètres du compte',
                style: TextStyle(
                  color: Color(0xFFFAFAFA),
                ),
              ),
            ),
            tileColor: AdaptiveTheme.of(context).theme.primaryColor,
          ),
          const ListTile(
            title: Center(
              child: Text(
                'Modifier mes informations',
                style: TextStyle(
                  color: Color(0xFF1F1D1D),
                ),
              ),
            ),
          ),
          const ListTile(
            title: Center(
              child: Text(
                'Désactiver mon compte',
                style: TextStyle(
                  color: Color(0xFF1F1D1D),
                ),
              ),
            ),
          ),
          const ListTile(
            title: Center(
              child: Text(
                'Options de confidentialité',
                style: TextStyle(
                  color: Color(0xFF1F1D1D),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Center(
              child: Text(
                "Paramètres de l'appli",
                style: TextStyle(
                  color: Color(0xFFFAFAFA),
                ),
              ),
            ),
            tileColor: AdaptiveTheme.of(context).theme.primaryColor,
          ),
          const ListTile(
            title: Center(
              child: Text(
                'Conditions générales',
                style: TextStyle(
                  color: Color(0xFF1F1D1D),
                ),
              ),
            ),
          ),
          const ListTile(
            title: Center(
              child: Text(
                'Politique de confidentialité',
                style: TextStyle(
                  color: Color(0xFF1F1D1D),
                ),
              ),
            ),
          ),
          const ListTile(
            title: Center(
              child: Text(
                'A propos',
                style: TextStyle(
                  color: Color(0xFF1F1D1D),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.20),
            child: FloatingActionButton.extended(
                onPressed: () {},
                icon: Icon(Icons.logout,color: Colors.white),
                label: const Text("Déconnexion",style: TextStyle(color: Colors.white),),
                backgroundColor: AdaptiveTheme.of(context).theme.primaryColor),
          ),
        ],
      ),
    );
  }

  void changeTheme() {
//     // sets theme mode to dark
// AdaptiveTheme.of(context).setDark();

// // sets theme mode to light
// AdaptiveTheme.of(context).setLight();

// // sets theme mode to system default
// AdaptiveTheme.of(context).setSystem();
    AdaptiveTheme.of(context).toggleThemeMode();
    AdaptiveTheme.getThemeMode().then((themeMode) {
      print(themeMode?.toString());
    });
  }
}
