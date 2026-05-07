import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/intro_screen.dart';

/// ─────────────────────────────────────────────
///  Entry point — Mahendra Talks
///  Dark + Yellow cinematic portfolio app
///
///  Launch sequence:
///    IntroScreen (3.5s) → LandingScreen → HomeShell
/// ─────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode (remove for landscape support)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar: transparent overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1A1A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MahendraTalksApp());
}

class MahendraTalksApp extends StatelessWidget {
  const MahendraTalksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahendra Talks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const IntroScreen(),
    );
  }
}
