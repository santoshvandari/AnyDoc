import 'package:anydoc/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnyDocApp());
}

class AnyDocApp extends StatelessWidget {
  const AnyDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AnyDoc App",
      home: HomeScreen(),
    );
  }
}
