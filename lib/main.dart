import 'package:brew_notes/screens/forgot_password_page.dart';
import 'package:brew_notes/screens/gallery_page.dart';
import 'package:brew_notes/screens/journal_page.dart';
import 'package:brew_notes/screens/landing_page.dart';
import 'package:brew_notes/screens/maps_page.dart';
import 'package:brew_notes/screens/profile_page.dart';
import 'package:brew_notes/screens/new_entry_page.dart';
import 'package:brew_notes/screens/home_page.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/home': (context) => const HomePage(),
        '/map': (context) => const MapsPage(),
        '/gallery': (context) => const GalleryPage(),
        '/journal': (context) => const JournalPage(),
        '/add': (context) => const EntryPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );

  }
}
