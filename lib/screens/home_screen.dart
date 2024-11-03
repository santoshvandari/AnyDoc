import 'package:anydoc/screens/recent_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF53826E),
                  Color(0xFF223A56),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text('AnyDoc'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: const RecentScreen(),
        floatingActionButton: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              colors: [
                Color(0xFF3e699c),
                Color(0xFF2a3f36),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FloatingActionButton(
            onPressed: () {
              // Adding the Action to be performed on Floating Action Button
              debugPrint('Floating Action Button Pressed');
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
