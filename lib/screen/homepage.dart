import 'dart:convert';
import 'dart:io';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/widget/profile_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:renconsport_flutter/screen/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final AppinioSwiperController controller = AppinioSwiperController();
  bool isLogged = true;
  int indexProfile = 0;
  Key _futureBuilderKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    checkLogged();
    return Column(
      children: [
        FutureBuilder<List<User>>(
          key: _futureBuilderKey,
          future: fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Column(
                children: [
                  FloatingActionButton(onPressed: () {
                    storage.delete(key: "token");
                    redirect();
                  }),
                  CupertinoPageScaffold(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: AppinioSwiper(
                            padding: const EdgeInsets.all(0),
                            backgroundCardsCount: 0,
                            swipeOptions: const AppinioSwipeOptions.symmetric(
                                horizontal: true),
                            unlimitedUnswipe: false,
                            controller: controller,
                            onSwiping: (AppinioSwiperDirection direction) {
                              debugPrint(direction.toString());
                            },
                            onSwipe: _swipe,
                            onEnd: _onEnd,
                            cardsCount: snapshot.data!.length,
                            cardsBuilder: (BuildContext context, int index) {
                              return ProfileCard(
                                candidate: snapshot.data![indexProfile],
                                controller: controller,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color:
                                AdaptiveTheme.of(context).theme.primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${snapshot.data![indexProfile].username},${(snapshot.data![indexProfile].age).toString()}",
                                style: const TextStyle(fontSize: 25)),
                            Text(
                              snapshot.data![indexProfile].city,
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        Text(
                          snapshot.data![indexProfile].bio,
                          style: const TextStyle(fontSize: 16),
                        )
                      ]),
                    ),
                  ),
                  // snapshot.data![9].avatarUrl != null
                  //     ? Text((snapshot.data![9].avatarUrl).toString())
                  //     : Text("url de l'image")
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  void checkLogged() async {
    if (!await storage.containsKey(key: "token")) {
      redirect();
    }
  }

  void redirect() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    setState(() {
      indexProfile++;
    });
  }

  void _onEnd() {
    setState(() {
      indexProfile = 0;
      _futureBuilderKey = UniqueKey();
    });
  }

  Future<List<User>> fetchUser() async {
    String? token = await storage.read(key: "token");
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
