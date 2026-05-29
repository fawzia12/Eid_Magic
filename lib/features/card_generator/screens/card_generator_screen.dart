import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CardGeneratorScreen extends StatefulWidget {
  const CardGeneratorScreen({super.key});

  @override
  State<CardGeneratorScreen> createState() => _CardGeneratorScreenState();
}

class _CardGeneratorScreenState extends State<CardGeneratorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey _cardKey = GlobalKey();
  bool _isGenerating = false;
  String _generatedName = '';
  String _selectedBlessing = '';

  final List<String> _blessings = [
    "May Allah protect you and guide your path ✨",
    "May this Eid bring you peace and happiness 🌙",
    "Stay blessed always 🌙",
  ];

  void _generateCard() {
    if (_nameController.text.trim().isEmpty) return;

    setState(() {
      _generatedName = _nameController.text;
      _isGenerating = true;
      _blessings.shuffle();
      _selectedBlessing = _blessings.first;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    });
  }

  Future<void> _shareCard() async {
    try {
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/eid_card.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFFFFD700)),
                const SizedBox(width: 12),
                Text(
                  'Creator Studio',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ).animate().fadeIn().slideX(begin: -0.2),

            const SizedBox(height: 32),

            if (_generatedName.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Floating Input Field
                    Container(
                      decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFFFD700).withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.1),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _nameController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Enter your name...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(24),
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                          begin: -5,
                          end: 5,
                          duration: 2.seconds,
                          curve: Curves.easeInOut,
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.5),

                    const SizedBox(height: 40),

                    ElevatedButton(
                          onPressed: _generateCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: const Color(0xFF0A1929),
                            minimumSize: const Size(200, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10,
                          ),
                          child: const Text(
                            'Generate Magic',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                  ],
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: RepaintBoundary(
                        key: _cardKey,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF00FF88), Color(0xFF0A1929)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FF88).withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                          child: Stack(
                            children: [
                              // Decorative Background pattern
                              Positioned(
                                right: -50,
                                top: -50,
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 200,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                              Positioned(
                                left: -30,
                                bottom: 20,
                                child: Icon(
                                  Icons.dark_mode_rounded,
                                  size: 150,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),

                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                          'عيد مبارك',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                                fontSize: 72,
                                                color: const Color(0xFFFFD700),
                                                height: 1,
                                              ),
                                        )
                                        .animate(
                                          onPlay: (c) =>
                                              c.repeat(reverse: true),
                                        )
                                        .shimmer(
                                          duration: 3.seconds,
                                          color: Colors.white,
                                        ),

                                    const SizedBox(height: 24),

                                    const Text(
                                          'EID MUBARAK',
                                          style: TextStyle(
                                            fontSize: 20,
                                            letterSpacing: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(duration: 800.ms)
                                        .slideY(begin: 0.3),

                                    const SizedBox(height: 60),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(
                                            0xFFFFD700,
                                          ).withOpacity(0.5),
                                        ),
                                      ),
                                      child:
                                          Text(
                                                _generatedName,
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                              .animate()
                                              .fadeIn(
                                                delay: 500.ms,
                                                duration: 800.ms,
                                              )
                                              .shimmer(
                                                delay: 1000.ms,
                                                duration: 2.seconds,
                                                color: const Color(0xFFFFD700),
                                              ),
                                    ),

                                    const SizedBox(height: 24),

                                    Text(
                                      _selectedBlessing,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ).animate().fadeIn(
                                      delay: 1000.ms,
                                      duration: 800.ms,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 800.ms,
                      curve: Curves.easeOutBack,
                    ),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _generatedName = '';
                              _nameController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white54,
                          ),
                          label: const Text(
                            'Reset',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                        ElevatedButton.icon(
                              onPressed: _shareCard,
                              icon: const Icon(
                                Icons.share,
                                color: Color(0xFF0A1929),
                              ),
                              label: const Text(
                                'Share Magic',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A1929),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFD700),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.05, 1.05),
                              duration: 1.seconds,
                            ),
                      ],
                    ).animate().fadeIn(delay: 800.ms),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
