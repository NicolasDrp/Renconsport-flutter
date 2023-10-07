import 'dart:convert';
import 'dart:io';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/services/user_service.dart';
import 'package:renconsport_flutter/widget/profile_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:renconsport_flutter/widget/tags.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.nav});

  final Function nav;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final AppinioSwiperController controller = AppinioSwiperController();
  bool isLogged = true;
  int indexProfile = 0;
  Key _futureBuilderKey = UniqueKey();
  late int idTarget;
  late String idToken;

  @override
  Widget build(BuildContext context) {
    checkLogged();
    getIdUser();
    UserService.getCurrentUserId();

    fetchUserNotLiked();
    return Column(
      children: [
        FutureBuilder<List<User>>(
          key: _futureBuilderKey,
          future: fetchUserNotLiked(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  //TODO : changer le heightFactor par plus optimiser
                  heightFactor: 11,
                  child: Text(
                    "Aucun utilisateur ne correspond à vos préférences",
                    style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                idTarget = snapshot.data![indexProfile].id;
                return Column(
                  children: [
                    Column(
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
                    Row(children: [
                      Tags(sports: ["Foot", "Basket", "Boxe"])
                    ]),
                    SizedBox(
                      height: 10,
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
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(
              heightFactor: 11,
              child: Column(
                children: [
                  Text(
                    "Chargement des utilisateurs",
                    style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge,
                  ),
                  CircularProgressIndicator(
                    color: AdaptiveTheme.of(context).theme.primaryColor,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void getIdUser() async {
    String idUSer = await UserService.getCurrentUserId();
    idToken = idUSer;
  }

  Future<List<User>> fetchUserNotLiked() async {
    List<User> listUser = await UserService.fetchUsers();
    User user = await UserService.fetchUserFuture(
        "/api/users/$idToken", UserService.getCurrentToken());

    List<String> idList =
        listUser.map((element) => element.id.toString()).toList();

    List<String> idLikeList =
        user.likeList.map((element) => element.target).toList();

    idList.removeWhere((element) => idLikeList.contains(element));
    idList.removeWhere((element) => idToken == (element));

    List<User> usersNotLiked = listUser
        .where((element) => idList.contains(element.id.toString()))
        .toList();

    return usersNotLiked;
  }

// TODO: vérifier utilité fonction
  void checkLogged() async {
    String? token;
    bool valid = false;
    if (await storage.containsKey(key: "token")) {
      token = await storage.read(key: "token");
      valid = await UserService.checkValidity(token!);
    }
    if (token == null) {
      redirect();
    } else {
      if (valid == true) {
        return;
      } else {
        redirect();
      }
    }
  }

  void redirect() {
    widget.nav(5, null);
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    if (direction.name == "left") {
      addLike(int.parse(idToken), idTarget, false);
    } else if (direction.name == "right") {
      addLike(int.parse(idToken), idTarget, true);
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

  Future<void> addLike(int idUser, int idTarget, bool isLike) async {
    String? token = await storage.read(key: "token");
    if (token == null) {
      throw Exception("Token not found");
    }

    String formattedToken = "Bearer $token";

    final response = await http.post(
      Uri.parse('$urlApi/likes'),
      headers: {
        HttpHeaders.authorizationHeader: formattedToken,
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: json.encode({
        "isLike": isLike,
        "sender": "api/users/$idUser",
        "target": "api/users/$idTarget",
      }),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to like');
    }
  }
}
