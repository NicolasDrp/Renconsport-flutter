import 'package:flutter/material.dart';
import 'package:renconsport_flutter/screen/Register.dart';
import 'package:renconsport_flutter/screen/contacts.dart';
import 'package:renconsport_flutter/screen/homepage.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:renconsport_flutter/screen/login.dart';
import 'package:renconsport_flutter/screen/parameters.dart';
import 'package:renconsport_flutter/screen/profile.dart';
import 'package:renconsport_flutter/screen/profile_settings.dart';
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
  late List<Widget> pageList;
  int pageIndex = 0;
  String currentTutorial = "placeholder"; // TODO: implement tutorial
  bool showBars = true;

  void navigateToPage(int index) {
    if (index != pageIndex) {
      setState(() {
        pageIndex = index;
      });
    }
    if (index == 5 || index == 6 || index == 7) {
      setState(() {
        showBars = false;
      });
    } else {
      setState(() {
        showBars = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pageList = [
      HomePage(nav: navigateToPage),
      const Sessions(),
      Contacts(nav: navigateToPage),
      Profile(nav: navigateToPage),
      Parameters(nav: navigateToPage),
      Login(nav: navigateToPage),
      Register(nav: navigateToPage),
      ProfileSettings(nav: navigateToPage)
    ];
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
        canvasColor: light,
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Color(0xFF1F1D1D), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFF1F1D1D), fontSize: 20),
          bodyLarge: TextStyle(color: Color(0xFF1F1D1D), fontSize: 24),
          labelMedium: TextStyle(color: secondaryLight, fontSize: 20),
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
        canvasColor: dark,
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Color(0xFFFAFAFA), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFFFAFAFA), fontSize: 20),
          bodyLarge: TextStyle(color: Color(0xFFFAFAFA), fontSize: 24),
          labelMedium: TextStyle(color: light, fontSize: 20),
        ),
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
          appBar: showBars
              ? CustomAppbar(
                  tutorial: currentTutorial,
                  callback: navigateToPage,
                )
              : null,
          body: pageList[pageIndex],
          bottomNavigationBar: showBars
              ? BottomAppBarWidget(
                  callback: navigateToPage,
                  currentPage: pageIndex,
                )
              : null,
        ),
      ),
    );
  }

  AdaptiveThemeMode? getUserTheme() {
    // ignore: prefer_typing_uninitialized_variables
    var theme;
    AdaptiveTheme.getThemeMode().then((themeMode) {
      theme = themeMode;
    });
    return theme;
  }
}
