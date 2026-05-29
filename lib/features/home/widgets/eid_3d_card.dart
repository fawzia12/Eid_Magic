import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:math';

class Eid3DCard extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final int index;
  final int tiltX;
  final int tiltY;

  const Eid3DCard({
    super.key,
    required this.cardData,
    required this.index,
    required this.tiltX,
    required this.tiltY,
  });

  @override
  State<Eid3DCard> createState() => _Eid3DCardState();
}

class _Eid3DCardState extends State<Eid3DCard> {
  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    double normX = widget.tiltX / 10000.0;
    double normY = widget.tiltY / 10000.0;

    normX = normX.clamp(-1.0, 1.0);
    normY = normY.clamp(-1.0, 1.0);

    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(normX * pi / 8)
      ..rotateY(normY * pi / 8);

    Color themeColor = widget.cardData['color'];

    return GestureDetector(
      onTapDown: (_) => setState(() => _isLongPressed = true),
      onTapUp: (_) => setState(() => _isLongPressed = false),
      onTapCancel: () => setState(() => _isLongPressed = false),
      onTap: () {
        if (widget.cardData['isGift'] == true) {
          context.push('/gift');
        }
      },
      child: Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: Hero(
          tag: 'card_${widget.index}',
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(_isLongPressed ? 0.6 : 0.2),
                    blurRadius: _isLongPressed ? 50 : 30,
                    spreadRadius: _isLongPressed ? 10 : 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeColor.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                          themeColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -50,
                          left: -50,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeColor.withOpacity(0.3),
                              backgroundBlendMode: BlendMode.screen,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                    widget.cardData['icon'],
                                    size: 80,
                                    color: themeColor,
                                  )
                                  .animate(
                                    onPlay: (c) =>
                                        widget.cardData['isGift'] == true
                                        ? c.repeat(reverse: true)
                                        : null,
                                  )
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.1, 1.1),
                                    duration: 1.seconds,
                                    curve: Curves.easeInOut,
                                  )
                                  .shimmer(
                                    duration: 1200.ms,
                                    color: Colors.white54,
                                  ),

                              const SizedBox(height: 32),
                              Text(
                                    widget.cardData['title'],
                                    style:
                                        widget.cardData['isCalligraphy'] == true
                                        ? Theme.of(
                                            context,
                                          ).textTheme.displayLarge?.copyWith(
                                            color: themeColor,
                                            fontWeight: FontWeight.bold,
                                          )
                                        : Theme.of(
                                            context,
                                          ).textTheme.displaySmall?.copyWith(
                                            color: themeColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    textAlign: TextAlign.center,
                                  )
                                  .animate()
                                  .fadeIn(duration: 800.ms)
                                  .slideY(
                                    begin: 0.2,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .shimmer(duration: 2.seconds, delay: 500.ms),

                              const SizedBox(height: 16),
                              Text(
                                    widget.cardData['subtitle'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                          height: 1.5,
                                        ),
                                    textAlign: TextAlign.center,
                                  )
                                  .animate()
                                  .fadeIn(delay: 400.ms, duration: 600.ms)
                                  .moveY(begin: 10, curve: Curves.easeOutCubic),

                              if (widget.cardData['isGift'] == true) ...[
                                const SizedBox(height: 24),
                                Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: themeColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: themeColor.withOpacity(0.5),
                                        ),
                                      ),
                                      child: const Text(
                                        'Tap to Reveal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (c) => c.repeat(reverse: true),
                                    )
                                    .fadeIn(duration: 600.ms),
                              ],
                            ],
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
      ),
    );
  }
}
