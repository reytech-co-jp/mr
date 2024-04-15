import 'dart:async';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mr/screen/FlipScreen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:video_player/video_player.dart';

class DiceScreen extends StatefulWidget {
  DiceScreen(this.deviceHeight, this.deviceWidth, this.diceImages, this.currentValue, this.currentPlan, {super.key});

  double deviceHeight;
  double deviceWidth;
  List<String> diceImages;
  int currentValue;
  String currentPlan;

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  late double deviceHeight;
  late double deviceWidth;
  late List<String> diceImages;
  late int currentValue;
  late String currentPlan;
  bool isRolling = false;
  bool isRolled = false;
  Timer? timer;
  int currentIndex = 0;
  int currentDuration = 0;
  late int rollingDuration;
  StreamSubscription? accelerometerSubscription;

  late VideoPlayerController player1;
  late VideoPlayerController player2;

  @override
  void initState() {
    super.initState();
    deviceHeight = widget.deviceHeight;
    deviceWidth = widget.deviceWidth;
    diceImages = widget.diceImages;
    currentValue = widget.currentValue;
    currentPlan = widget.currentPlan;
    rollingDuration = 385;
    timer = null;
    player1 = VideoPlayerController.asset('assets/sounds/dice.wav');
    player2 = VideoPlayerController.asset('assets/sounds/piko.mp3');
    player1.initialize().then((_) {
      setState(() {});
    });
    player2.initialize().then((_) {
      setState(() {});
    });

    accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!isRolling && (event.z.abs() > 15)) {
        accelerometerSubscription?.cancel();
        rollDice();
      }
    });
  }

  @override
  void dispose() async {
    accelerometerSubscription?.cancel();
    timer?.cancel();
    // player1.stop();
    // player2.stop();
    player1.dispose();
    player2.dispose();
    super.dispose();
  }

  void rollDice() {
    if (isRolling) {
      return;
    }

    setState(() {
      isRolling = true;
    });

    player1.play();

    int rotationCounter = 0;

    timer = Timer.periodic(Duration(milliseconds: rollingDuration), (timer) async {
      setState(() {
        currentIndex = (rotationCounter);
      });

      rotationCounter++;
      if (rotationCounter >= diceImages.length) {
        timer.cancel();
        await Future.delayed(const Duration(milliseconds: 1000));
        if (isRolling) {
          setState(() {
            isRolled = true;
          });
          player2.play();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8e6c0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                isRolled ? plan(deviceHeight, deviceWidth, currentValue, currentPlan) : Container(),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      rollDice();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: deviceHeight * 0.35),
                      width: deviceHeight / 3,
                      height: deviceHeight / 3,
                      child: Image.asset(diceImages[currentIndex]),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceHeight * 0.1),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                dispose();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlipScreen(deviceHeight, deviceWidth),
                  ),
                );
              },
              child: BorderedText(
                strokeWidth: 8.0,
                strokeColor: Colors.white,
                child: Text(
                  'フリップにもどる',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceHeight * 0.07,
                    fontFamily: "SlacksideOne-Regular",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container plan(double deviceHeight, double deviceWidth, int planNo, String planText) {
    const List<Color> planColors = [
      Color(0xffff9ec8),
      Color(0xfffd9989),
      Color(0xffd594c6),
      Color(0xfff3b92f),
      Color(0xff6ab7e5),
      Color(0xffbbd063),
    ];
    String diceNo = "dice$planNo";
    Color planColor = planText.isEmpty ? Colors.grey : planColors[planNo - 1];
    return Container(
      margin: EdgeInsets.only(top: deviceHeight * 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: deviceWidth * 0.97,
                height: deviceHeight * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: planColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: deviceWidth * 0.03),
                    child: Image.asset(
                      "images/dice/$diceNo.png",
                      width: deviceHeight * 0.075,
                      height: deviceHeight * 0.075,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: deviceWidth * 0.015),
                    width: deviceWidth * 0.75,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        planText,
                        style: TextStyle(
                          fontSize: deviceHeight * 0.05,
                          fontFamily: "NotoSansJP-Bold",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
