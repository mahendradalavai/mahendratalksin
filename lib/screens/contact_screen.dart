import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/glow_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/social_icon.dart';

/// ─────────────────────────────────────────────
///  ContactScreen — Tab 3  "Let's Collaborate"
///  Email CTA · Social icons · Form · Footer
///
///  Update WhatsApp link with real number:
///    'https://wa.me/91XXXXXXXXXX'
/// ─────────────────────────────────────────────
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl= TextEditingController();
  final _msgCtrl  = TextEditingController();
  bool _sending   = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'mahendradalavai7@gmail.com',
      query: 'subject=Collaboration Inquiry',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _sending = false);
    _nameCtrl.clear();
    _emailCtrl.clear();
    _msgCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppTheme.accent,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.black, size: 20),
            const SizedBox(width: 10),
            Text('✓  Message sent',
                style: AppTheme.labelBold(color: Colors.black)),
          ],
        ),
      ),
    );
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
            title: Text("LET'S COLLABORATE",
                style: AppTheme.headingMedium(color: AppTheme.accent, size: 18)),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),

                Text(
                  'Brand collabs, paid promos, or just say hi.',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium(size: 14),
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 28),

                // Email CTA
                GlowButton(
                  label: 'mahendradalavai7@gmail.com',
                  icon: Icons.mail_rounded,
                  onPressed: _launchEmail,
                  width: double.infinity,
                  height: 52,
                  fontSize: 13,
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 32),

                // Social icons
                _buildSocialRow(),

                const SizedBox(height: 36),

                // Contact form
                _buildForm(),

                const SizedBox(height: 40),

                // Footer
                _buildFooter(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Social row ────────────────────────────────
  Widget _buildSocialRow() {
    return Column(
      children: [
        Text('Find me on', style: AppTheme.headingMedium(size: 18)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SocialIcon(
              icon: FontAwesomeIcons.instagram,
              url: 'https://www.instagram.com/mahendratalks.in?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==',
              label: 'Instagram',
              color: const Color(0xFFE1306C),
            ),
            SocialIcon(
              icon: FontAwesomeIcons.envelope,
              url: 'mailto:mahendradalavai7@gmail.com?subject=Collaboration%20Inquiry',
              label: 'Email',
              color: const Color(0xFFFFC107),
            ),
            SocialIcon(
              icon: FontAwesomeIcons.whatsapp,
              url: 'https://wa.me/918185012513',
              label: 'WhatsApp',
              color: const Color(0xFF25D366),
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideY(begin: 0.1);
  }

  // ── Contact form ──────────────────────────────
  Widget _buildForm() {
    return GlassCard(
      accentBorder: true,
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send a Message', style: AppTheme.headingMedium(size: 20)),
            const SizedBox(height: 20),

            _field(
              ctrl: _nameCtrl, label: 'Your Name',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _field(
              ctrl: _emailCtrl, label: 'Your Email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _msgCtrl,
              maxLines: 4,
              style: AppTheme.bodyLarge(size: 14),
              cursorColor: AppTheme.accent,
              decoration: _deco(label: 'Your Message', icon: Icons.message_outlined),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter a message' : null,
            ),
            const SizedBox(height: 20),

            _sending
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accent, strokeWidth: 2.5),
                  )
                : GlowButton(
                    label: 'Send Message',
                    icon: Icons.send_rounded,
                    onPressed: _submit,
                    width: double.infinity,
                    height: 52,
                  ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms)
        .slideY(begin: 0.15, end: 0);
  }

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: AppTheme.bodyLarge(size: 14),
      cursorColor: AppTheme.accent,
      decoration: _deco(label: label, icon: icon),
      validator: validator,
    );
  }

  InputDecoration _deco({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTheme.bodyMedium(size: 13),
      prefixIcon:
          Icon(icon, color: AppTheme.accent.withValues(alpha: 0.6), size: 20),
      filled: true,
      fillColor: AppTheme.background,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.accent, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      errorStyle: AppTheme.bodyMedium(color: Colors.redAccent, size: 11),
    );
  }

  // ── Footer ────────────────────────────────────
  Widget _buildFooter() {
    return Center(
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: 'Made with ', style: AppTheme.bodyMedium(size: 12)),
          const TextSpan(text: '❤️', style: TextStyle(fontSize: 14)),
          TextSpan(text: ' by Mahendra',
              style: AppTheme.bodyMedium(color: AppTheme.accent, size: 12)),
        ]),
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 500.ms);
  }
}
