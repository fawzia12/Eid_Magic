import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:confetti/confetti.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math';

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  bool _isOpened = false;
  String? _awardedSticker;

  final List<String> _stickers = [
    '🌙 Crescent Moon',
    '⭐ Golden Star',
    '🕌 Majestic Mosque',
    '🏮 Glowing Lantern',
    '🐪 Desert Camel',
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _listenToShake();
  }

  void _listenToShake() {
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      if (_isOpened) return;

      final double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      if (acceleration > 20.0) {
        _openGift();
      }
    });
  }

  Future<void> _openGift() async {
    setState(() {
      _isOpened = true;
      _awardedSticker = _stickers[Random().nextInt(_stickers.length)];
    });

    if (await Haptics.canVibrate()) {
      await Haptics.vibrate(HapticsType.heavy);
    }

    _confettiController.play();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by MainLayout
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Spotlight effect
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.0,
                colors: [
                  const Color(0xFFFFD700).withOpacity(0.3), // Spotlight
                  Colors.black.withOpacity(0.8), // Dark room edge
                ],
                stops: const [0.1, 1.0],
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 100,
              minBlastForce: 20,
              emissionFrequency: 0.1,
              numberOfParticles: 50,
              gravity: 0.5,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isOpened)
                GestureDetector(
                  onTap: _openGift,
                  child:
                      Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withOpacity(0.4),
                                  blurRadius: 60,
                                  spreadRadius: 15,
                                ),
                              ],
                            ),
                            child: Lottie.asset(
                              'assets/Gift box.json',
                              fit: BoxFit.contain,
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.05, 1.05),
                            duration: 800.ms,
                            curve: Curves.easeInOut,
                          ),
                ),

              if (!_isOpened)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Text(
                    'Shake phone or tap to open!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.5),
                ),

              if (_isOpened)
                Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.3),
                            blurRadius: 50,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'You Found:',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            _awardedSticker ?? '',
                            style: const TextStyle(
                              fontSize: 40,
                              color: Color(0xFFFFD700),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.elasticOut)
                    .fadeIn(duration: 400.ms)
                    .shimmer(duration: 2.seconds, color: Colors.white24),
            ],
          ),
        ],
      ),
    );
  }
}
