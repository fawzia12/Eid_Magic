import 'package:eid_magic/core/theme/theme_provider.dart';
import 'package:eid_magic/core/providers/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final audioProvider = context.watch<AudioProvider>();
    final isFitr = themeProvider.isFitr;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fadeIn().slideX(begin: -0.2, curve: Curves.easeOutCubic),
            
            const SizedBox(height: 40),
            
            // Glassmorphic Panel
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      _buildThemeToggle(context, themeProvider, isFitr),
                      const Divider(color: Colors.white24, height: 40),
                      _buildToggleRow(context, Icons.volume_up_rounded, 'Sound Effects', audioProvider.soundEffectsEnabled, (val) => audioProvider.toggleSoundEffects()),

                    ],
                  ),
                ).animate().scale(begin: const Offset(0.9, 0.9), duration: 600.ms, curve: Curves.easeOutCubic).fadeIn(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider provider, bool isFitr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFitr ? Icons.wb_sunny_rounded : Icons.nightlight_round, 
                color: const Color(0xFFFFD700)
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('App Theme', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(isFitr ? 'Eid al-Fitr (Oasis)' : 'Eid al-Adha (Desert)', style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ],
        ),
        Switch(
          value: !isFitr,
          activeColor: const Color(0xFFFFD700),
          onChanged: (val) => provider.toggleTheme(),
        )
      ],
    );
  }

  Widget _buildToggleRow(BuildContext context, IconData icon, String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white70),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Switch(
          value: value,
          activeColor: const Color(0xFFFFD700),
          onChanged: onChanged,
        )
      ],
    );
  }
}
