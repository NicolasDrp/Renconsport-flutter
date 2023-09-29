import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:renconsport_flutter/services/router.dart';
import 'package:renconsport_flutter/services/custom_theme_data.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const String urlApi = "https://renconsport-api.osc-fr1.scalingo.io/api";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late List<String> tutorialList;
  int pageIndex = 0;
  int currentTutorial = 0; // TODO: implement tutorial
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
    tutorialList = CustomRouter.tutorialList;
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveThemeMode? savedThemeMode = getUserTheme();
    return AdaptiveTheme(
      light: CustomThemeData.lightTheme,
      dark: CustomThemeData.darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'RenconSport',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: Scaffold(
          appBar: showBars
              ? CustomAppbar(
                  tutorial: tutorialList[currentTutorial],
                  callback: navigateToPage,
                )
              : null,
          body: CustomRouter(index: pageIndex, nav: navigateToPage),
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
    AdaptiveThemeMode? theme;
    AdaptiveTheme.getThemeMode().then((themeMode) {
      theme = themeMode;
    });
    return theme;
  }
}
