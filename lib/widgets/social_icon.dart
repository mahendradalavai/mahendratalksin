import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

/// ─────────────────────────────────────────────
///  SocialIcon — Circular social button
///  with yellow border glow on tap
/// ─────────────────────────────────────────────
class SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final String label;
  final Color? color;

  const SocialIcon({
    super.key,
    required this.icon,
    required this.url,
    required this.label,
    this.color,
  });

  @override
  State<SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<SocialIcon> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _hovered = true),
          onTapUp: (_) {
            setState(() => _hovered = false);
            _launch();
          },
          onTapCancel: () => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? AppTheme.accent.withValues(alpha: 0.15)
                  : AppTheme.surface,
              border: Border.all(
                color: _hovered
                    ? AppTheme.accent
                    : AppTheme.accent.withValues(alpha: 0.4),
                width: _hovered ? 2 : 1.5,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              widget.icon,
              color: _hovered
                  ? AppTheme.accent
                  : (widget.color ?? AppTheme.textSecondary),
              size: 24,
            ),
          ),
        ).animate().scale(
              begin: const Offset(1, 1),
              end: const Offset(1, 1),
            ),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: AppTheme.bodyMedium(size: 11),
        ),
      ],
    );
  }
}
