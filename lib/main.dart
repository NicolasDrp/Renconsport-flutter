import 'package:flutter/material.dart';
import 'package:renconsport_flutter/screen/contacts.dart';
import 'package:renconsport_flutter/screen/homepage.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:renconsport_flutter/screen/parameters.dart';
import 'package:renconsport_flutter/screen/profile.dart';
import 'package:renconsport_flutter/screen/sessions.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';

const String urlApi = "https://renconsport-api.osc-fr1.scalingo.io/api";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<Widget> pageList = [
    const HomePage(),
    const Sessions(),
    const Contacts(),
    const Profile(),
    const Parameters()
  ];
  int pageIndex = 0;
  String currentTutorial = "placeholder"; // TODO: implement tutorial

  void navigateToPage(int index) {
    if (index != pageIndex) {
      setState(() {
        pageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveThemeMode? savedThemeMode = getUserTheme();
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
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF1F1D1D), fontSize: 20),
          bodyLarge: TextStyle(color: Color(0xFF1F1D1D), fontSize: 24),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: light, unselectedItemColor: dark),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: primary,
        hintColor: secondaryDark,
        cardColor: dark,
        textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Color(0xFFFAFAFA), fontSize: 20),
            bodyLarge: TextStyle(color: Color(0xFFFAFAFA), fontSize: 24)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: primary, unselectedItemColor: light),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'RenconSport',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: Scaffold(
            appBar: CustomAppbar(
              tutorial: currentTutorial,
              callback: navigateToPage,
            ),
            body: pageList[pageIndex],
            bottomNavigationBar: BottomAppBarWidget(
              callback: navigateToPage,
              currentPage: pageIndex,
            )),
      ),
    );
  }

  AdaptiveThemeMode? getUserTheme() {
    var theme;
    AdaptiveTheme.getThemeMode().then((themeMode) {
      theme = themeMode;
    });
    return theme;
  }
}
