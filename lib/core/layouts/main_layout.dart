import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../theme/theme_provider.dart';
import '../../features/home/widgets/particle_painter.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _particles = Particle.generate(80, MediaQuery.of(context).size);
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/card-generator')) return 1;
    if (location.startsWith('/gift')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/card-generator');
        break;
      case 2:
        context.go('/gift');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isFitr = themeProvider.isFitr;
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Global Deep Radial Night-Sky Gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.8, -0.6),
                radius: 1.5,
                colors: [
                  isFitr ? const Color(0xFF1A365D) : const Color(0xFF2C1E0A),
                  const Color(0xFF0A1929),
                  const Color(0xFF050B14),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Animated Crescent Moon
          Positioned(
            top: 80,
            right: 20,
            child: const Icon(
              Icons.dark_mode,
              size: 120,
              color: Color(0x33FFD700),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 4.seconds, curve: Curves.easeInOut)
             .shimmer(duration: 3.seconds, color: Colors.white10),
          ),

          // Global Background Particles
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    _particleController.value, 
                    _particles,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),

          // The active screen content
          widget.child,
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: _buildFloatingGlassNavBar(currentIndex, context),
        ),
      ),
    );
  }

  Widget _buildFloatingGlassNavBar(int currentIndex, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_rounded, 0, currentIndex, context),
              _buildNavItem(Icons.edit_document, 1, currentIndex, context),
              _buildNavItem(Icons.redeem_rounded, 2, currentIndex, context),
              _buildNavItem(Icons.settings_rounded, 3, currentIndex, context),
            ],
          ),
        ).animate().slideY(begin: 1.5, duration: 800.ms, curve: Curves.easeOutCubic),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, int currentIndex, BuildContext context) {
    final isSelected = currentIndex == index;
    final color = isSelected ? const Color(0xFFFFD700) : Colors.white54;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: isSelected ? 32 : 28,
            ).animate(target: isSelected ? 1 : 0)
             .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 300.ms, curve: Curves.easeOutBack)
             .tint(color: const Color(0xFFFFD700), duration: 300.ms),
             
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFD700),
                      blurRadius: 5,
                      spreadRadius: 2,
                    )
                  ]
                ),
              ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack)
          ],
        ),
      ),
    );
  }
}
