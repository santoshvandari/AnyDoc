import 'package:anydoc/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnyDocApp());
}

class AnyDocApp extends StatelessWidget {
  const AnyDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AnyDoc App",
      theme: ThemeData(
        primaryColor: const Color(0xFF53826E),
        primaryColorDark: const Color(0xFF223A56),
        scaffoldBackgroundColor: const Color(0xFF2A3F36),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF53826E),
          secondary: const Color(0xFF3E699C),
          surface: const Color(0xFF223A56),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF223A56),
          foregroundColor: Colors.white,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF3E699C),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
