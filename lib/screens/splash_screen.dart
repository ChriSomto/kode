import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradclock/screens/countdown_screen.dart';
import 'package:gradclock/screens/widget_setup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final List<String> _words = ['brilliant', 'loved', 'unstoppable', 'cherished', 'celebrated'];
  int _wordIndex = 0;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Cycle words every ~800ms
    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_wordIndex < _words.length - 1) {
        setState(() => _wordIndex++);
      } else {
        timer.cancel();
      }
    });

    // Navigate after 4 seconds
    Future.delayed(const Duration(seconds: 4), _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;
    bool seen = false;
    try {
      final prefs = await SharedPreferences.getInstance()
          .timeout(const Duration(seconds: 2));
      seen = prefs.getBool('widget_setup_seen') ?? false;
    } catch (_) {
      seen = false; // if prefs hangs, just go to setup screen
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => seen ? const CountdownScreen() : const WidgetSetupScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(const Color(0xFFC2185B), const Color.fromARGB(255, 133, 141, 12), _gradientController.value)!,
                  Color.lerp(const Color(0xFF880E4F), const Color(0xFFC2185B), _gradientController.value)!,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You are',
                    style: GoogleFonts.nunito(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Text(
                      _words[_wordIndex],
                      key: ValueKey<int>(_wordIndex),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}