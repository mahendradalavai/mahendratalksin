import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glow_button.dart';
import 'home_shell.dart';

/// ─────────────────────────────────────────────
///  LandingScreen — 3D Hero / Welcome
///
///  To use a real 3D phone model, replace the
///  _buildPhoneShape() section inside
///  _buildPhoneModel() with:
///
///    import 'package:model_viewer_plus/model_viewer_plus.dart';
///    ModelViewer(
///      src: 'assets/models/phone.glb',
///      autoRotate: true,
///      cameraControls: true,
///      backgroundColor: Colors.transparent,
///    )
/// ─────────────────────────────────────────────
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _rotateCtrl;
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotateCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 8),
    )..repeat();

    _glowCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _rotateCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _enterPortfolio() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeShell(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04), end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background gradient
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppTheme.heroGradient),
            child: SizedBox.expand(),
          ),

          // Animated particle dots
          ..._buildParticles(size),

          // Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height - 80),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildTopBar(),
                    const SizedBox(height: 16),
                    _buildPhoneModel(size),
                    const SizedBox(height: 28),
                    _buildHeadline(),
                    const SizedBox(height: 32),
                    _buildStats(),
                    const SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: GlowButton(
                        label: 'Enter Portfolio',
                        onPressed: _enterPortfolio,
                        width: double.infinity,
                        height: 56,
                        fontSize: 16,
                        icon: Icons.arrow_forward_rounded,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar ──────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Mahendra Talks',
          style: GoogleFonts.bebasNeue(
              fontSize: 26, color: AppTheme.textPrimary, letterSpacing: 2),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.verified, color: Color(0xFF1DA1F2), size: 20),
      ],
    ).animate().fadeIn(duration: 700.ms).slideY(begin: -0.3, end: 0);
  }

  // ── 3D Phone model placeholder ────────────────
  Widget _buildPhoneModel(Size size) {
    final phoneH = size.height * 0.38;
    return AnimatedBuilder(
      animation: Listenable.merge([_floatCtrl, _rotateCtrl, _glowCtrl]),
      builder: (_, __) {
        final floatOffset  = math.sin(_floatCtrl.value * math.pi) * 10;
        final glowIntensity = 0.4 + _glowCtrl.value * 0.4;
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Container(
            height: phoneH,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow behind phone
                Container(
                  width: 180, height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accent.withValues(alpha: 0.15 * glowIntensity),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Phone shape with 3D perspective
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(
                        _rotateCtrl.value * 2 * math.pi * 0.3 - math.pi / 8),
                  child: _buildPhoneShape(phoneH * 0.85),
                ),
              ],
            ),
          ),
        );
      },
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildPhoneShape(double height) {
    final width = height * 0.48;
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF2C2C2C), Color(0xFF111111)],
        ),
        border: Border.all(
            color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.2),
            blurRadius: 30, spreadRadius: 4,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 20, offset: Offset(8, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Container(
            width: 60, height: 6,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.accent.withValues(alpha: 0.08),
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_fill,
                      color: AppTheme.accent, size: 36),
                  const SizedBox(height: 8),
                  Text('Reels',
                      style: AppTheme.labelBold(
                          color: AppTheme.accent, size: 11)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ── Headline ──────────────────────────────────
  Widget _buildHeadline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Text(
            'I create cinematic reels\n& teach editing.',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
              fontSize: 32,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
              height: 1.15,
            ),
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 700.ms)
              .slideY(begin: 0.3),
          const SizedBox(height: 10),
          Text(
            'Welcome to my world — tap below to explore.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium(size: 14),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
        ],
      ),
    );
  }

  // ── Stats row ─────────────────────────────────
  Widget _buildStats() {
    final stats = [
      {'label': 'Followers', 'value': '1K+'},
      {'label': 'Reels',     'value': '12'},
      {'label': 'Country',   'value': '🇮🇳'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stats.asMap().entries.map((e) {
        final i = e.key;
        final s = e.value;
        return Row(
          children: [
            if (i != 0)
              Container(
                width: 1, height: 32,
                color: AppTheme.border,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
            Column(
              children: [
                Text(s['value']!,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 26, color: AppTheme.accent, letterSpacing: 1)),
                Text(s['label']!, style: AppTheme.bodyMedium(size: 11)),
              ],
            ),
          ],
        );
      }).toList(),
    )
        .animate()
        .fadeIn(delay: 900.ms, duration: 600.ms)
        .slideY(begin: 0.2);
  }

  // ── Particles ─────────────────────────────────
  List<Widget> _buildParticles(Size size) {
    final rng = math.Random(7);
    return List.generate(20, (i) {
      final x     = rng.nextDouble() * size.width;
      final y     = rng.nextDouble() * size.height;
      final sz    = 1.5 + rng.nextDouble() * 3;
      final delay = rng.nextInt(3000);
      return Positioned(
        left: x, top: y,
        child: Container(
          width: sz, height: sz,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accent.withValues(alpha: 0.35),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(delay: Duration(milliseconds: delay), duration: 2000.ms)
            .then()
            .fadeOut(duration: 2000.ms),
      );
    });
  }
}
