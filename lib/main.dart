import 'package:brew_notes/screens/forgot_password_page.dart';
import 'package:brew_notes/screens/gallery_page.dart';
import 'package:brew_notes/screens/journal_page.dart';
import 'package:brew_notes/screens/landing_page.dart';
import 'package:brew_notes/screens/maps_page.dart';
import 'package:brew_notes/screens/profile_page.dart';
import 'package:brew_notes/screens/new_entry_page.dart';
import 'package:brew_notes/screens/home_page.dart';
import 'package:brew_notes/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const BrewNotes());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Failed to initialize Firebase: $e")),
      ),
    ));
  }
}

class BrewNotes extends StatelessWidget {
  const BrewNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: 'Brew Notes',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/home': (context) => const HomePage(),
          '/map': (context) => const MapsPage(),
          '/gallery': (context) => const GalleryPage(),
          '/journal': (context) => const JournalPage(),
          '/add': (context) => const EntryPage(),
          '/profile': (context) => const ProfilePage(),
          '/forgot': (context) => const ForgotPassword(),
        },
      ),
    );
  }
}
