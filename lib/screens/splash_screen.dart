import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradclock/screens/countdown_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final List<String> _words = [
    'brilliant',
    'loved',
    'unstoppable',
    'cherished',
    'celebrated',
    'going higher'
  ];
  int _wordIndex = 0;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeController.forward();

    Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_wordIndex < _words.length - 1) {
        setState(() => _wordIndex++);
      } else {
        timer.cancel();
      }
    });

    Future.delayed(const Duration(seconds: 5), _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CountdownScreen()),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Her photo as full background
          Image.asset(
            'assets/icon/icon.jpeg',
            fit: BoxFit.cover,
          ),

          // Dark gradient overlay so text is readable
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x55000000), // subtle dark at top
                  Color(0xCC000000), // darker at bottom for text
                ],
              ),
            ),
          ),

          // Text content
          Center(
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'you are',
                    style: GoogleFonts.nunito(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 22,
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
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}