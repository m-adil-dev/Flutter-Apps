import "package:audioplayers/audioplayers.dart";
import 'package:flutter/material.dart';
import 'package:skyways/screens/home_pages/home_page.dart';

class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({super.key});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _buttonShakeAnimation;
  
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    // Initialize Audio Player
    _audioPlayer = AudioPlayer();
    _playSuccessSound();

    // Animation controller setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Scale Animation (Elastic Out)
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    // Rotation Animation for the checkmark icon
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Fade-in animation for text
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Button Shake Animation
    _buttonShakeAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Start animations
    _controller.forward();

    // Auto navigate back or to home after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();  // Don't forget to dispose the audio player
    _controller.dispose();
    super.dispose();
  }

_playSuccessSound() async {
  try {
await _audioPlayer.play(AssetSource('assets/success_sound.mp3'));

    print('Sound played');
  } catch (e) {
    print('Error playing sound: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    final Color themeColor = const Color.fromARGB(255, 104, 46, 19);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rotating Checkmark Icon with Scaling Animation
                  Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14, // 360° rotation
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: themeColor,
                        child: const Icon(Icons.check, size: 80, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Booking Successful Text with Fade-In Effect
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: const Text(
                      'Booking Successful!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtext with Fade-In Effect
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: const Text(
                      'Your seat has been successfully booked.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Shake Animation for the Button
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_buttonShakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: ElevatedButton(
                      onPressed: () {
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomePage(isStateBooking: false,)),
  (route) => false, // This removes all previous routes in the stack
);

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Optional: A subtle fade-in animation for "Powered by SkyWays"
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: const Text(
                      'Powered by SkyWays',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
