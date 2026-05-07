import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme/app_theme.dart';
import 'landing_screen.dart';

/// ─────────────────────────────────────────────
///  IntroScreen — 3D Animated Splash
///  Uses `assets/models/logo.glb` with ModelViewer
///  + brand reveal animation -> LandingScreen
/// ─────────────────────────────────────────────
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _glowCtrl;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 3500), _goToLanding);
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _goToLanding() {
    if (_navigating || !mounted) return;
    _navigating = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LandingScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Radial glow background
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    AppTheme.accent
                        .withValues(alpha: 0.03 + _glowCtrl.value * 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Floating particles
          ..._buildParticles(size),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _build3DLogo(),
                const SizedBox(height: 32),
                Text(
                  'MAHENDRA TALKS',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 38,
                    color: AppTheme.accent,
                    letterSpacing: 4,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1200.ms, duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                Text(
                  'C I N E M A T I C   R E E L S  &  E D I T S',
                  style: AppTheme.tagline(color: AppTheme.textSecondary),
                ).animate().fadeIn(delay: 1700.ms, duration: 600.ms),
                const SizedBox(height: 40),
                _buildLoader(),
              ],
            ),
          ),

          // Skip button
          Positioned(
            top: 52,
            right: 20,
            child: TextButton(
              onPressed: _goToLanding,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppTheme.accent.withValues(alpha: 0.5),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text('Skip  →',
                  style: AppTheme.labelBold(color: AppTheme.accent, size: 13)),
            ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
          ),
        ],
      ),
    );
  }

  // ── Rotating 3D logo ─────────────────────────
  Widget _build3DLogo() {
    final isMobile = MediaQuery.of(context).size.shortestSide < 600;
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleCtrl, _glowCtrl]),
      builder: (_, __) {
        final scale = Curves.elasticOut.transform(_scaleCtrl.value);
        final glow = 0.5 + _glowCtrl.value * 0.5;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.16 * glow),
                  blurRadius: 24 * glow,
                  spreadRadius: 3 * glow,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFF202020), Color(0xFF090909)],
                    ),
                    border: Border.all(
                      color: AppTheme.accent.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..setEntry(3, 2, 0.001),
                  child: _buildLogoModel(isMobile),
                ),
                IgnorePointer(
                  child: _buildMtSymbol(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMtSymbol() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'MT',
          style: GoogleFonts.bebasNeue(
            fontSize: 34,
            color: AppTheme.accent.withValues(alpha: 0.95),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.verified_rounded, color: Color(0xFF1DA1F2), size: 18),
      ],
    );
  }

  Widget _buildLogoModel(bool isMobile) {
    return SizedBox(
      width: 140,
      height: 140,
      child: ModelViewer(
        src: 'assets/models/logo.glb',
        alt: 'Mahendra Talks logo model',
        autoRotate: true,
        autoPlay: true,
        disableZoom: isMobile,
        cameraControls: !isMobile,
        interactionPrompt: InteractionPrompt.none,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  // ── Animated loading dots ─────────────────────
  Widget _buildLoader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accent.withValues(alpha: 0.6),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .fadeIn(delay: Duration(milliseconds: 200 * i), duration: 400.ms)
            .then()
            .fadeOut(duration: 400.ms);
      }),
    ).animate().fadeIn(delay: 2000.ms, duration: 400.ms);
  }

  // ── Particle dots ─────────────────────────────
  List<Widget> _buildParticles(Size size) {
    final rng = math.Random(42);
    return List.generate(18, (i) {
      final x = rng.nextDouble();
      final y = rng.nextDouble();
      final sz = 2.0 + rng.nextDouble() * 3;
      final delay = rng.nextInt(2000);
      return Positioned(
        left: size.width * x,
        top: size.height * y,
        child: Container(
          width: sz,
          height: sz,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accent.withValues(alpha: 0.4),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(delay: Duration(milliseconds: delay), duration: 1500.ms)
            .then()
            .fadeOut(duration: 1500.ms),
      );
    });
  }
}
