import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/theme_app.dart';
import 'package:tictactoe/pages/game_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: GAME_TITLE,
      theme: themeApp,
      home: CustomSplash(
          imagePath: 'assets/images/splash-screen.png',
          logoSize: 200,
          duration: 3000,
          backGroundColor: Colors.purple,
          home: GamePage()),
    );
  }
}
