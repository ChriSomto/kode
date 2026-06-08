import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradclock/screens/countdown_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetSetupScreen extends StatelessWidget {
  const WidgetSetupScreen({super.key});

  Future<void> _dismiss(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('widget_setup_seen', true); // never show again
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CountdownScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC2185B), Color(0xFF969339)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add gradclock to your home screen',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: const Color(0xFF3D2000),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 36),
                ...[
                  ('1. Long press your home screen', 'Find an empty spot and hold down'),
                  ('2. Tap Widgets', 'Look for the Widgets option that appears'),
                  ('3. Find gradclock', 'Scroll through the list to find it'),
                  ('4. Drag it to your screen', 'Hold and place it where you like'),
                ].map(
                  (step) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$1,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3D2000),
                          ),
                        ),
                        Text(
                          step.$2,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: const Color(0xFF3D2000).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () => _dismiss(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Got it!',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3D2000),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}