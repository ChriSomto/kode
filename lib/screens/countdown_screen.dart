import 'dart:async';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradclock/screens/message_screen.dart';
import 'package:gradclock/services/audio_service.dart';
import 'package:gradclock/services/scheduling_service.dart';
import 'package:home_widget/home_widget.dart';
import 'package:timezone/timezone.dart' as tz;

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  Duration _duration = const Duration();
  late ConfettiController _confettiController;
  late AnimationController _gradientController;
  bool _isPlaying = false; // FIX: proper bool declaration
  bool _confettiPlayed = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _gradientController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);

    _updateDuration();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateDuration());

    _isPlaying = (audioHandler as GradclockAudioHandler?)?.isPlaying ?? false;
  }

  void _updateDuration() {
    final location =  
        tz.getLocation(testMode ? 'Africa/Lagos' : 'Asia/Manila');
    final now = tz.TZDateTime.now(location);
    final target = testMode
        ? tz.TZDateTime(location, 2026, 6, 8, 6, 0)
        : tz.TZDateTime(location, 2026, 6, 9, 0, 0);
    if (mounted) {
      setState(() {
        _duration = target.difference(now);
        _isPlaying = (audioHandler as GradclockAudioHandler?)?.isPlaying ?? false;
      });
    }
    if (_duration.inSeconds <= 0 && !_confettiPlayed) {
      _confettiPlayed = true;
      _confettiController.play();
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const MessageScreen(payload: '1'),
          ),
        );
      }
    }
    _writeWidgetData();
  }

  Future<void> _writeWidgetData() async {
    final d = _duration;
    final countdownStr = d.inSeconds > 0
        ? '${d.inDays}d ${d.inHours.remainder(24)}h ${d.inMinutes.remainder(60)}m'
        : "It's your day, Angela!";
    await HomeWidget.saveWidgetData<String>('countdown', countdownStr);
    await HomeWidget.updateWidget(androidName: 'GradclockWidgetProvider');
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await audioHandler?.pause();
    } else {
      await audioHandler?.play();
    }
    setState(() => _isPlaying = (audioHandler as GradclockAudioHandler?)?.isPlaying ?? false);
  }

  @override
  void dispose() {
    _timer.cancel();
    _confettiController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _duration.inDays.clamp(0, 999);
    final hours = _duration.inHours.remainder(24).clamp(0, 23);
    final minutes = _duration.inMinutes.remainder(60).clamp(0, 59);
    final seconds = _duration.inSeconds.remainder(60).clamp(0, 59);

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
                  Color.lerp(const Color(0xFFC2185B), const Color(0xFFE65100),
                      _gradientController.value)!,
                  Color.lerp(const Color(0xFF880E4F), const Color(0xFFC2185B),
                      _gradientController.value)!,
                ],
              ),
            ),
            child: Stack(
              children: [
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'gradclock',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Angela, Cum Laude',
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 48),
                        _buildCountdown(days, hours, minutes, seconds),
                        const SizedBox(height: 24),
                        Text(
                          'Something beautiful is coming, Angela',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        if (_isPlaying) ...[
                          const SizedBox(height: 48),
                          GestureDetector(
                            onTap: _toggleAudio,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                'Pause Song',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Color(0xFFC2185B),
                      Color(0xFFE65100),
                      Colors.white
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountdown(int days, int hours, int minutes, int seconds) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildUnit(days, 'DAYS'),
              _buildSep(),
              _buildUnit(hours, 'HRS'),
              _buildSep(),
              _buildUnit(minutes, 'MIN'),
              _buildSep(),
              _buildUnit(seconds, 'SEC'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnit(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.white.withOpacity(0.85),
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        ':',
        style: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}