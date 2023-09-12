import 'dart:developer';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/widgets/ProfileCard.dart';
import 'package:renconsport_flutter/widgets/example_candidate_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widgets/bottomAppBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppinioSwiperController controller = AppinioSwiperController();
  bool isLogged = true;
  @override
  Widget build(BuildContext context) {
    // checkLogged();
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_appbar.png'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.error_outline,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(),
      body: Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/test');
            },
          ),
          Text("homepage"),
          CupertinoPageScaffold(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: AppinioSwiper(
                    padding: EdgeInsets.all(0),
                    backgroundCardsCount: 0,
                    swipeOptions:
                        const AppinioSwipeOptions.symmetric(horizontal: true),
                    unlimitedUnswipe: true,
                    controller: controller,
                    unswipe: _unswipe,
                    onSwiping: (AppinioSwiperDirection direction) {
                      debugPrint(direction.toString());
                    },
                    onSwipe: _swipe,
                    onEnd: _onEnd,
                    cardsCount: candidates.length,
                    cardsBuilder: (BuildContext context, int index) {
                      return ProfileCard(
                        candidate: candidates[index],
                        controller: controller,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void checkLogged() async {
    if (!await widget.storage.containsKey(key: "token")) {
      redirect();
    } else {
      print(await widget.storage.read(key: "token"));
    }
  }

  void redirect() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    log("the card was swiped to the: " + direction.name);
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    log("end reached!");
  }
}
