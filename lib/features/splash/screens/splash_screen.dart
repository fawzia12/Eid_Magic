import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   
    Timer(const Duration(milliseconds: 5500), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient Glow Background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  const Color(0xFF1A365D).withOpacity(0.8),
                  const Color(0xFF0A1929),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),

          // Floating background stars
          ...List.generate(20, (index) {
            final random = Random();
            return Positioned(
              left: random.nextDouble() * MediaQuery.of(context).size.width,
              top: random.nextDouble() * MediaQuery.of(context).size.height,
              child:
                  Container(
                        width: random.nextDouble() * 3 + 1,
                        height: random.nextDouble() * 3 + 1,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(duration: (random.nextInt(1000) + 1000).ms)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.5, 1.5),
                      ),
            );
          }),

          // Center Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.15),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: Lottie.asset(
                  'assets/spalsh.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -8, end: 8, duration: 3000.ms, curve: Curves.easeInOutSine)
              .animate() // Initial entry
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 1500.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 1000.ms),

              const SizedBox(height: 50),

             
              Row(
                mainAxisSize: MainAxisSize.min,
                children: 'EID MUBARAK'.split('').map((char) {
                  return Text(
                    char == ' ' ? '   ' : char, 
                    style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      shadows: [
                        Shadow(
                          color: Color(0xFFFFD700),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  );
                }).toList()
                .animate(interval: 120.ms, delay: 1000.ms) // Letter-by-letter
                .fadeIn(duration: 600.ms, curve: Curves.easeIn)
                .moveY(begin: 15, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
                .shimmer(duration: 2500.ms, color: const Color(0xFFFFD700), curve: Curves.easeInOutSine),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
