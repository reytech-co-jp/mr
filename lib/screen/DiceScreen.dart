import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({Key? key}) : super(key: key);

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  late List<String> diceImages;
  bool isRolling = false;
  late int currentValue;
  late Timer timer;
  late int rollingDuration;
  int lastValue = -1;
  late bool isShaking;
  final AudioPlayer player = AudioPlayer();
  int rotationCount = 18;

  @override
  void initState() {
    super.initState();
    diceImages = List.generate(
      6,
      (index) => "images/dice/red_dice${index + 1}.png",
    );
    currentValue = 1;
    rollingDuration = 340;
  }

  void rollDice() {
    player.play(AssetSource("sounds/dice.mp3"));
    setState(() {
      isRolling = true;
    });

    int totalDuration = rollingDuration * rotationCount;
    int currentDuration = 0;
    int rotationCounter = 0;

    timer = Timer.periodic(Duration(milliseconds: rollingDuration), (timer) {
      int newValue;
      do {
        newValue = Random().nextInt(6) + 1;
      } while (newValue == lastValue);
      lastValue = newValue;
      setState(() {
        currentValue = newValue;
      });
      currentDuration += rollingDuration;
      rotationCounter++;
      if (rotationCounter >= rotationCount) {
        timer.cancel();
        setState(() {
          isRolling = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xfff8e6c0),
      body: Center(
        child: GestureDetector(
          onTap: !isRolling ? rollDice : null,
          child: Container(
            width: deviceHeight / 3,
            height: deviceHeight / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(diceImages[currentValue - 1]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
