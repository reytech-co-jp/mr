import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mr/model/Flip.dart';
import 'package:mr/screen/DiceScreen.dart';

class FlipScreen extends StatefulWidget {
  FlipScreen(this.flip, {super.key});

  Flip flip;

  @override
  State<FlipScreen> createState() => _FlipScreenState();
}

class _FlipScreenState extends State<FlipScreen> {
  static const List<Color> planColors = [
    Color(0xffff9ec8),
    Color(0xfffd9989),
    Color(0xffd594c6),
    Color(0xfff3b92f),
    Color(0xff6ab7e5),
    Color(0xffbbd063),
  ];

  late Flip flip;

  @override
  void initState() {
    super.initState();
    flip = widget.flip;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    String titleText = flip.title;
    return Scaffold(
      backgroundColor: const Color(0xfff8e6c0),
      body: Center(
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.06,
                ),
                GestureDetector(
                  onTap: () async {
                    String? newTitle = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return TextEditingDialog(text: titleText);
                      },
                    );
                    setState(() {
                      flip.title = newTitle ?? "";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            width: deviceWidth * 0.97,
                            height: deviceHeight * 0.13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight,
                                colors: [
                                  const Color(0xfff8e6c0).withOpacity(0.6),
                                  const Color(0xfffccd74).withOpacity(0.6),
                                  const Color(0xfffc8396).withOpacity(0.6),
                                ],
                                stops: const [0.0, 0.4, 1.0],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: deviceWidth * 0.015),
                                width: deviceHeight * 0.1,
                                height: deviceHeight * 0.1,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/sa.png',
                                    width: deviceHeight * 0.07,
                                  ),
                                ),
                              ),
                              titleText.isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.only(left: deviceWidth * 0.015),
                                      width: deviceWidth * 0.7,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          titleText,
                                          style: TextStyle(
                                            fontSize: deviceHeight * 0.06,
                                            fontFamily: "YuseiMagic-Regular",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                plan(deviceHeight, deviceWidth, 1),
                plan(deviceHeight, deviceWidth, 2),
                plan(deviceHeight, deviceWidth, 3),
                plan(deviceHeight, deviceWidth, 4),
                plan(deviceHeight, deviceWidth, 5),
                plan(deviceHeight, deviceWidth, 6),
                Container(
                  margin: EdgeInsets.only(top: deviceHeight * 0.032),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      flip.plan.where((element) => element.isNotEmpty).length > 1
                          ? GestureDetector(
                              onTap: () {
                                List<int> planNoList = [];
                                for (int i = 0; i < 6; i++) {
                                  if (flip.plan[i] != "") {
                                    planNoList.add(i + 1);
                                  }
                                }

                                List<String> diceImages = [];
                                int currentValue = -1;
                                int lastValue = -1;
                                for (int i = 0; i <= 16; i++) {
                                  if (lastValue != -1) {
                                    planNoList.add(lastValue);
                                  }
                                  currentValue = planNoList[Random().nextInt(planNoList.length - 1)];
                                  diceImages.add("images/dice/red_dice$currentValue.png");
                                  lastValue = currentValue;
                                  planNoList.remove(currentValue);
                                }
                                dispose();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiceScreen(
                                      diceImages,
                                      currentValue,
                                      flip.plan[currentValue - 1],
                                      flip,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: deviceWidth * 0.1),
                                width: deviceWidth * 0.6,
                                child: Image.asset(
                                  'images/lets_dice.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Container(width: deviceWidth * 0.6),
                      Container(
                        margin: EdgeInsets.only(right: deviceWidth * 0.04),
                        alignment: Alignment.center,
                        width: deviceHeight * 0.08,
                        height: deviceHeight * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 3.5,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.delete,
                            size: deviceHeight * 0.045,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('フリップを削除します。'),
                                      Text('よろしいですか？'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('キャンセル'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          flip.title = "";
                                          flip.plan[0] = "";
                                          flip.plan[1] = "";
                                          flip.plan[2] = "";
                                          flip.plan[3] = "";
                                          flip.plan[4] = "";
                                          flip.plan[5] = "";
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('削除'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container plan(double deviceHeight, double deviceWidth, int planNo) {
    String diceNo = "dice$planNo";
    String planText = flip.plan[planNo - 1];
    Color planColor = planText.isEmpty ? Colors.grey : planColors[planNo - 1];
    return Container(
      margin: EdgeInsets.only(top: deviceHeight * 0.01),
      child: GestureDetector(
        onTap: () async {
          String? newPlan = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return TextEditingDialog(text: planText);
            },
          );
          setState(() {
            flip.plan[planNo - 1] = newPlan ?? "";
          });
        },
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
                    planText.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(left: deviceWidth * 0.015),
                            width: deviceWidth * 0.75,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                planText,
                                style: TextStyle(
                                  fontSize: deviceHeight * 0.06,
                                  fontFamily: "YuseiMagic-Regular",
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextEditingDialog extends StatefulWidget {
  const TextEditingDialog({super.key, this.text});

  final String? text;

  @override
  State<TextEditingDialog> createState() => _TextEditingState();
}

class _TextEditingState extends State<TextEditingDialog> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = widget.text ?? '';
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        autofocus: true,
        focusNode: focusNode,
        controller: controller,
        onFieldSubmitted: (_) {
          Navigator.of(context).pop(controller.text);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text('完了'),
        )
      ],
    );
  }
}
