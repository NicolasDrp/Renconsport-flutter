import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/screen/contacts.dart';
import 'package:renconsport_flutter/screen/homepage.dart';
import 'package:renconsport_flutter/screen/login.dart';
import 'package:renconsport_flutter/screen/parameters.dart';
import 'package:renconsport_flutter/screen/profile.dart';
import 'package:renconsport_flutter/screen/profile_settings.dart';
import 'package:renconsport_flutter/screen/sessions.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

const String urlApi = "https://renconsport-api.osc-fr1.scalingo.io/api";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MainApp(storage: storage, savedThemeMode: savedThemeMode));
}

class MainApp extends StatelessWidget {
  final FlutterSecureStorage storage;
  final AdaptiveThemeMode? savedThemeMode;

  const MainApp(
      {required this.storage, super.key, required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFFFB7819);
    const Color secondaryLight = Color(0xFF1482C2);
    const Color secondaryDark = Color(0xFF004989);
    const Color light = Color(0xFFFAFAFA);
    const Color dark = Color(0xFF1F1D1D);
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primary,
        hintColor: secondaryLight,
        cardColor: primary,
        textTheme: TextTheme(
            bodyMedium: TextStyle(color: Color(0xFF1F1D1D), fontSize: 20),
            bodyLarge: TextStyle(color: Color(0xFF1F1D1D), fontSize: 24)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: light, unselectedItemColor: dark),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: primary,
        hintColor: secondaryDark,
        cardColor: dark,
        textTheme: TextTheme(
            bodyMedium: TextStyle(color: Color(0xFFFAFAFA), fontSize: 20),
            bodyLarge: TextStyle(color: Color(0xFFFAFAFA), fontSize: 24)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: primary, unselectedItemColor: light),
      ),
      debugShowFloatingThemeButton: true,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'RenconSport',
        theme: theme,
        darkTheme: darkTheme,
        routes: {
          '/': (context) => HomePage(storage: storage),
          '/login': (context) => Login(storage: storage),
          '/profile': (context) => Profile(storage: storage),
          '/sessions': (context) => Sessions(storage: storage),
          '/parameters': (context) =>
              Parameters(storage: storage, savedThemeMode: savedThemeMode),
          '/contacts': (context) => Contacts(storage: storage),
          '/profile_settings': (context) => ProfileSettings(storage: storage),
        },
      ),
    );
  }
}
