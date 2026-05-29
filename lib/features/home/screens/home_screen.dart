import 'package:eid_magic/core/providers/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

import '../widgets/eid_3d_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController _swiperController = CardSwiperController();

  final List<Map<String, dynamic>> _cards = [
    {
      'title': 'عيد مبارك',
      'subtitle':
          'May this special day bring peace, happiness, and prosperity to everyone.',
      'icon': Icons.star_rounded,
      'color': const Color(0xFF00FF88),
      'isCalligraphy': true,
    },
    {
      'title': 'Blessings',
      'subtitle': 'Wishing you a joyous Eid filled with love and laughter.',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFFFD700),
      'isCalligraphy': false,
    },
    {
      'title': 'Virtual Gift',
      'subtitle': 'You have received a special gift! Tap to reveal.',
      'icon': Icons.redeem_rounded,
      'color': const Color(0xFFFF5722),
      'isGift': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AudioProvider>().startHomeMusic();
      }
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Animated Greeting Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 19.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                          'Eid Magic ✨',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .shimmer(duration: 2.seconds, delay: 500.ms),
                    const SizedBox(height: 4),
                    Text(
                          'Flip through magical memories',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 800.ms)
                        .slideY(begin: 0.2),
                  ],
                ),
              ],
            ),
          ),

          // 3D Card Carousel
          Expanded(
            child: CardSwiper(
              controller: _swiperController,
              cardsCount: _cards.length,
              numberOfCardsDisplayed: min(3, _cards.length),
              backCardOffset: const Offset(0, 40),
              // Increased padding here to decrease the physical size of the cards
              padding: const EdgeInsets.symmetric(
                horizontal: 48.0,
                vertical: 20,
              ),
              isLoop: true,
              allowedSwipeDirection: const AllowedSwipeDirection.all(),
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) {
                    final card = _cards[index];
                    return Eid3DCard(
                      cardData: card,
                      index: index,
                      tiltX: percentThresholdY,
                      tiltY: -percentThresholdX,
                    );
                  },
            ),
          ),
          const SizedBox(height: 80), // Space for bottom nav
        ],
      ),
    );
  }
}

