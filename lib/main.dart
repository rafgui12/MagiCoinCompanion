import 'package:flutter/material.dart';
import 'package:magicoincompanion/page/UserMagiCoin.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black, // Set the cursor color to black
      ),
    ),
    home: UserMagiCoin(),
  );
}
