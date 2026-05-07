import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// ─────────────────────────────────────────────
///  GlowButton — Amber gradient CTA button
///  with subtle pulsing glow effect
/// ─────────────────────────────────────────────
class GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final double fontSize;
  final IconData? icon;
  final bool outlined;

  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 54,
    this.fontSize = 15,
    this.icon,
    this.outlined = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: widget.outlined
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppTheme.accent, width: 1.5),
                  color: Colors.transparent,
                  boxShadow: _pressed ? AppTheme.yellowGlow : [],
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: AppTheme.buttonGradient,
                  boxShadow: _pressed
                      ? AppTheme.yellowGlow
                      : [
                          BoxShadow(
                            color: AppTheme.accent.withValues(alpha: 0.25),
                            blurRadius: 16,
                            spreadRadius: 1,
                          )
                        ],
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.outlined
                      ? AppTheme.accent
                      : AppTheme.background,
                  size: 18,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTheme.labelBold(
                  color: widget.outlined
                      ? AppTheme.accent
                      : AppTheme.background,
                  size: widget.fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          duration: 3000.ms,
          color: widget.outlined
              ? AppTheme.accent.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.08),
        );
  }
}
