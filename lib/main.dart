import 'package:brew_notes/screens/forgotPassword_page.dart';
import 'package:brew_notes/screens/landing_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BrewNotes());
}

class BrewNotes extends StatelessWidget {
  const BrewNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brew Notes',
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
