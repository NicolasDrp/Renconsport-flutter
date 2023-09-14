import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/widgets/ProfileCard.dart';
import 'package:renconsport_flutter/widgets/example_candidate_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widgets/bottomAppBar.dart';
import 'package:http/http.dart' as http;

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
    checkLogged();
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
          FutureBuilder<List<User>>(
            future: fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Column(
                  children: [
                    Text(snapshot.data![1].username),
                    Text((snapshot.data![1].age).toString()),
                    Text(snapshot.data![1].city),
                    Text(snapshot.data![1].bio)
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
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

  Future<List<User>> fetchUser() async {
    String? token = await widget.storage.read(key: "token");
    if (token == null) {
      throw Exception(
          ("Token not found")); // Gérer le cas où le token n'est pas disponible
    }
    final response = await http.get(
        Uri.parse('https://renconsport-api.osc-fr1.scalingo.io/api/users'),
        headers: {
          HttpHeaders.authorizationHeader: token,
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final result = jsonDecode(response.body);
      return List.generate(result['hydra:member'].length, (i) {
        return User.fromJson(result['hydra:member'][i]);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load User');
    }
  }
}
