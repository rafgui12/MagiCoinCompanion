import 'package:flutter/material.dart';
import 'package:magicoincompanion/page/MagiCoin.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: MagiCoin(),
  );
}
