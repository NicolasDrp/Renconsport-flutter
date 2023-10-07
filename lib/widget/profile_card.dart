import 'package:appinio_swiper/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/widget/swap_button.dart';

class ProfileCard extends StatelessWidget {
  final User candidate;
  final AppinioSwiperController controller;

  const ProfileCard({
    Key? key,
    required this.candidate,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage((candidate.avatar != null) ? candidate.avatar : "assets/placeholder_avatar.png")),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment
                            .bottomCenter, // Align the text to the bottom center
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Add padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              swipeLeftButton(controller),
                              swipeRightButton(controller),
                              // unswipeButton(controller),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
