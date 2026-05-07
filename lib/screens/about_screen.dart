import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

/// ─────────────────────────────────────────────
///  AboutScreen — Tab 1
///  Profile · Bio · Stats chips · Feature cards
///
///  To show a real photo: replace the Icon()
///  placeholder inside the ClipOval with:
///    Image.asset('assets/images/profile.png',
///      width: 100, height: 100, fit: BoxFit.cover)
/// ─────────────────────────────────────────────
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _profileImagePath = 'assets/images/profile.png';

  Future<bool> _hasProfileImage() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    return manifest.listAssets().contains(_profileImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.background,
            title: Text('ABOUT',
                style: AppTheme.headingMedium(color: AppTheme.accent, size: 18)),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                _buildProfile(context),
                const SizedBox(height: 28),
                _buildStatsChips(),
                const SizedBox(height: 32),
                Text('What I Do', style: AppTheme.headingMedium(size: 20))
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  icon: Icons.movie_creation_rounded,
                  title: 'Video Editing',
                  description:
                      'Cinematic cuts, smooth transitions & color grading that make every frame pop.',
                  delay: 600,
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  icon: Icons.auto_awesome_rounded,
                  title: 'CapCut Tutorials',
                  description:
                      'Trending edits anyone can recreate — from beginner to pro in minutes.',
                  delay: 750,
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  icon: Icons.smart_toy_rounded,
                  title: 'AI Editing',
                  description:
                      'Next-gen reels powered by AI tools — automate, enhance, and wow your audience.',
                  delay: 900,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile ───────────────────────────────────
  Widget _buildProfile(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accent, width: 2.5),
                boxShadow: AppTheme.yellowGlow,
              ),
              child: ClipOval(
                child: Container(
                  color: AppTheme.surface,
                  child: FutureBuilder<bool>(
                    future: _hasProfileImage(),
                    builder: (_, snap) {
                      if (snap.data == true) {
                        return Image.asset(
                          _profileImagePath,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      }
                      return Icon(
                        Icons.person,
                        size: 54,
                        color: AppTheme.accent.withValues(alpha: 0.6),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF1DA1F2),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.background, width: 2),
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Name + verified tick
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mahendra Talks',
              style: GoogleFonts.bebasNeue(
                  fontSize: 28,
                  color: AppTheme.textPrimary,
                  letterSpacing: 1.5),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.verified, color: Color(0xFF1DA1F2), size: 20),
          ],
        ),
        const SizedBox(height: 4),
        Text('@mahendratalks.in',
            style: AppTheme.bodyMedium(color: AppTheme.accent, size: 13)),
        const SizedBox(height: 12),
        Text(
          'Hi, I am Mahendra. I create cinematic reels, share practical\nediting tutorials, and teach simple AI workflows for creators.',
          textAlign: TextAlign.center,
          style: AppTheme.bodyMedium(size: 13),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.15, end: 0);
  }

  // ── Stats chips ───────────────────────────────
  Widget _buildStatsChips() {
    final chips = ['1K+ Followers', '12 Reels', '🇮🇳 India'];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: chips.map((label) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppTheme.accent.withValues(alpha: 0.4)),
            color: AppTheme.accent.withValues(alpha: 0.08),
          ),
          child: Text(label,
              style: AppTheme.labelBold(color: AppTheme.accent, size: 12)),
        );
      }).toList(),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.2);
  }

  // ── Feature card ──────────────────────────────
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return GlassCard(
      accentBorder: true,
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.accent.withValues(alpha: 0.12),
              border: Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: AppTheme.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.labelBold(size: 15)),
                const SizedBox(height: 4),
                Text(description, style: AppTheme.bodyMedium(size: 12)),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 500.ms)
        .slideX(begin: 0.1, end: 0);
  }
}
