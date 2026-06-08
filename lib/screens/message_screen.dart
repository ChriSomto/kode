import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradclock/services/audio_service.dart';

class MessageScreen extends StatefulWidget {
  final String payload;
  const MessageScreen({super.key, required this.payload});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool _isPlaying = false;

  static const String _msg1 =
      "MIDNIGHT. June 9th. Your day is officially here, Angela.\n\n"
      "Femi is up in spirit, counting down with you across every mile. "
      "You did it. Cum laude. Let that sink in.\n\n"
      "Tonight feels like New Year's Eve but better — because this is YOUR new year. "
      "A new chapter, a new version of you that already worked so hard and proved everyone right.\n\n"
      "I am SO proud of you. Now celebrate — you deserve every second of this.";

  static const String _msg2 =
      "Hey you.\n\n"
      "Just checking in on my favorite cum laude graduate. "
      "I hope today has been everything you deserved.\n\n"
      "I am so proud of you — not just for the degree, not just for the cum laude — "
      "but for every late night, every hard moment, every time you kept going.\n\n"
      "You are brilliant, you are resilient, and you are so deeply loved. "
      "Enjoy every second of today. The best is still ahead of you.\n\n"
      "— Femi";

  static const LinearGradient _grad1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF880E4F), Color(0xFFC2185B)],
  );

  static const LinearGradient _grad2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC2185B), Color(0xFFE65100)],
  );

  @override
  void initState() {
    super.initState();
    if (widget.payload == '1') {
      _startAudio();
    }
  }

  Future<void> _startAudio() async {
    await audioHandler?.play();
    if (mounted) setState(() => _isPlaying = true);
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await audioHandler?.pause();
    } else {
      await audioHandler?.play();
    }
    if (mounted) setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMoment1 = widget.payload == '1';
    final String message = isMoment1 ? _msg1 : _msg2;
    final LinearGradient gradient = isMoment1 ? _grad1 : _grad2;

    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: gradient),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 19,
                          color: Colors.white,
                          height: 1.7,
                        ),
                      ),
                      if (isMoment1) ...[
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
                              _isPlaying ? 'Pause Song' : 'Play Song',
                              style: GoogleFonts.nunito(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Text(
                        'tap anywhere to go back',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}