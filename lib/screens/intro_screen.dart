import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'landing_screen.dart';

/// ─────────────────────────────────────────────
///  IntroScreen — 3D Animated Splash
///  Rotating logo + brand name → LandingScreen
///
///  To use a real 3D model, replace _build3DLogo()
///  with ModelViewer:
///    import 'package:model_viewer_plus/model_viewer_plus.dart';
///    ModelViewer(src: 'assets/models/logo.glb',
///      autoRotate: true, backgroundColor: Colors.transparent)
/// ─────────────────────────────────────────────
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateCtrl;
  late AnimationController _scaleCtrl;
  late AnimationController _glowCtrl;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    _rotateCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 6),
    )..repeat();

    _scaleCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2500),
    )..forward();

    _glowCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 3500), _goToLanding);
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
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
                    AppTheme.accent.withValues(alpha: 0.05 + _glowCtrl.value * 0.06),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    return AnimatedBuilder(
      animation: Listenable.merge([_rotateCtrl, _scaleCtrl, _glowCtrl]),
      builder: (_, __) {
        final scale = Curves.elasticOut.transform(_scaleCtrl.value);
        final glow  = 0.5 + _glowCtrl.value * 0.5;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.3 * glow),
                  blurRadius: 40 * glow,
                  spreadRadius: 10 * glow,
                ),
              ],
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_rotateCtrl.value * 2 * math.pi)
                ..rotateX(math.pi / 12),
              child: _buildLogoFace(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoFace() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF2C2100), Color(0xFF0F0F0F)],
        ),
        border: Border.all(color: AppTheme.accent, width: 2.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110, height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accent.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('MT',
                  style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                      color: AppTheme.accent,
                      letterSpacing: 2,
                      height: 1)),
              Container(width: 50, height: 1.5, color: AppTheme.accent),
              const SizedBox(height: 3),
              Text('TALKS',
                  style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: AppTheme.accent.withValues(alpha: 0.7),
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
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
          width: 6, height: 6,
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
      final x     = rng.nextDouble();
      final y     = rng.nextDouble();
      final sz    = 2.0 + rng.nextDouble() * 3;
      final delay = rng.nextInt(2000);
      return Positioned(
        left: size.width * x,
        top:  size.height * y,
        child: Container(
          width: sz, height: sz,
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
