import 'package:appinio_swiper/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/widgets/swapButton.dart';

import 'example_candidate_model.dart';

class ProfileCard extends StatelessWidget {
  final ExampleCandidateModel candidate;
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
                gradient: candidate.color,
                image: DecorationImage(
                    image: AssetImage("assets/background_login.png")),
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
