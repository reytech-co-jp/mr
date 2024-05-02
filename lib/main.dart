import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr/model/Flip.dart';
import 'package:mr/screen/FlipScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Flip flip = Flip(
      title: "サイコロの旅",
      plan: ["青森", "新潟", "松山", "盛岡", "下関", "羽田"],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlipScreen(flip),
    );
  }
}
