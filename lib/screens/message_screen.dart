import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:gradclock/services/audio_service.dart'; // commented out — audio disabled for now

class MessageScreen extends StatefulWidget {
  final String payload;
  const MessageScreen({super.key, required this.payload});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // bool _isPlaying = false; // commented out — audio disabled for now

  static const String _msg1 =
      "omg .\n\n"
      "june 9th is finally here, babyyy(m gonna scream).\n\n"
      "i've been thinking about this day for like forever, "
      "but every single day i watched you carry the weight of everything you were building. "
      "every late night. every moment you were exhausted but kept going anyway. "
      "every time you chose discipline over rest, chose the future over the easy way out.\n\n"
      "you did it babyyyyyyyy. cum laude.\n\n"
      "let that sink in. really sit with it. "
      "because that's not luck, that's you. that's your mind, your heart, your work. "
      "nobody can take that from you. ever.\n\n"
      "i'm on the other side of the world right now and i swear i feel this moment like i'm right there. "
      "i'm proud of you in a way i don't even have the right words for. "
      "the kind of proud that sits quiet and deep.\n\n"
      "you are brilliant. you've always been brilliant. "
      "but today the world gets to see what i've always known.\n\n"
      "celebrate tonight. laugh loud. let people love on you. "
      "you earned every single second of this.\n\n"
      "i love you,my baby angela. more than you know.\n\n"
      "— your baby boy femi";

  static const String _msg2 =
      "hey beautiful-sexy-hot-smart-cute-tasty-cum-laude-graduate.\n\n"
      "just checking in on my world smartest and most pretty gf.\n\n"
      "i hope today has been everything you deserved, "
      "the feeling of walking across that stage knowing you gave everything you had.\n\n"
      "i am so proud of you. not just for the degree. not just for the cum laude. "
      "but for who you are, the way you love, the way you work, for being you"
      "the way you never let hard things break you\n\n"
      "you are brilliant. you are resilient. and you are so deeply loved.\n\n"
      "enjoy every second of today. the best is still ahead of you, im rootinng for you baby \n\n"
      "— your baby boy femi";

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
    // if (widget.payload == '1') { _startAudio(); } // commented out — audio disabled for now
  }

  // Future<void> _startAudio() async {
  //   await audioHandler?.play();
  //   if (mounted) setState(() => _isPlaying = true);
  // }

  // Future<void> _toggleAudio() async {
  //   if (_isPlaying) {
  //     await audioHandler?.pause();
  //   } else {
  //     await audioHandler?.play();
  //   }
  //   if (mounted) setState(() => _isPlaying = !_isPlaying);
  // }

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
                          height: 1.8,
                        ),
                      ),
                      // ── play/pause button commented out ──
                      // if (isMoment1) ...[
                      //   const SizedBox(height: 48),
                      //   GestureDetector(
                      //     onTap: _toggleAudio,
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white.withOpacity(0.3),
                      //         borderRadius: BorderRadius.circular(50),
                      //       ),
                      //       child: Text(
                      //         _isPlaying ? 'pause song' : 'play song',
                      //         style: GoogleFonts.nunito(
                      //           fontSize: 17,
                      //           fontWeight: FontWeight.w600,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      const SizedBox(height: 40),
                      Text(
                        'tap anywhere to go back',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.4),
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