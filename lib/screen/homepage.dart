import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/widget/ProfileCard.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
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
  int indexProfile = 0;
  Key _futureBuilderKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    checkLogged();
    return Scaffold(
      //TODO: Rédiger le tutorial de la homepage
      appBar: const CustomAppbar(tutorial: ""),
      bottomNavigationBar: BottomAppBarWidget(),
      body: Column(
        children: [
          FutureBuilder<List<User>>(
            key: _futureBuilderKey,
            future: fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Column(
                  children: [
                    CupertinoPageScaffold(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: AppinioSwiper(
                              padding: EdgeInsets.all(0),
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
                          side: BorderSide(color: Color(0xFFFB7819)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${snapshot.data![indexProfile].username},${(snapshot.data![indexProfile].age).toString()}",
                                  style: TextStyle(fontSize: 25)),
                              Text(
                                snapshot.data![indexProfile].city,
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          Text(
                            snapshot.data![indexProfile].bio,
                            style: TextStyle(fontSize: 16),
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
    print(direction);
    if (direction == AppinioSwiperDirection.left) {
      print("swipe à gauche");
    }
    if (direction == AppinioSwiperDirection.left) {
      print("swipe à droite");
    }
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
