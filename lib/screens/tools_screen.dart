import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

/// ─────────────────────────────────────────────
///  ToolsScreen — Tab 2  "My Creator Stack"
///  2-column grid of tappable tool cards
/// ─────────────────────────────────────────────
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  static const List<_Tool> _tools = [
    _Tool(name: 'CapCut',          desc: 'Mobile video editor',
          url: 'https://capcut.com',          icon: Icons.cut_rounded,
          color: Color(0xFF00C4CC)),
    _Tool(name: 'Remove.bg',       desc: 'AI background removal',
          url: 'https://remove.bg',           icon: Icons.layers_clear_rounded,
          color: Color(0xFF7C3AED)),
    _Tool(name: 'Canva',           desc: 'Graphics & thumbnails',
          url: 'https://canva.com',           icon: Icons.design_services_rounded,
          color: Color(0xFF00C4CC)),
    _Tool(name: 'Pexels',          desc: 'Free stock footage',
          url: 'https://pexels.com',          icon: Icons.photo_library_rounded,
          color: Color(0xFF05A081)),
    _Tool(name: 'Runway',          desc: 'AI video magic',
          url: 'https://runwayml.com',        icon: Icons.smart_toy_outlined,
          color: Color(0xFFFF4D4D)),
    _Tool(name: 'Epidemic Sound',  desc: 'Royalty-free audio',
          url: 'https://epidemicsound.com',   icon: Icons.music_note_rounded,
          color: Color(0xFFFF8C00)),
  ];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
            title: Text('MY CREATOR STACK',
                style: AppTheme.headingMedium(color: AppTheme.accent, size: 18)),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'The tools I use every day to create cinematic content.',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium(size: 13),
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: _tools.length,
                  itemBuilder: (ctx, i) => _ToolCard(
                    tool: _tools[i],
                    delay: 100 + i * 80,
                    onTap: () => _launch(_tools[i].url),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tool model ────────────────────────────────
class _Tool {
  final String name;
  final String desc;
  final String url;
  final IconData icon;
  final Color color;

  const _Tool({
    required this.name, required this.desc,
    required this.url,  required this.icon, required this.color,
  });
}

// ── Tool Card ──────────────────────────────────
class _ToolCard extends StatefulWidget {
  final _Tool tool;
  final int delay;
  final VoidCallback onTap;

  const _ToolCard({
    required this.tool, required this.delay, required this.onTap,
  });

  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A), Color(0xFF222222)],
            ),
            border: Border.all(
              color: _pressed
                  ? widget.tool.color.withValues(alpha: 0.6)
                  : AppTheme.border,
              width: 1.2,
            ),
            boxShadow: [
              if (_pressed)
                BoxShadow(
                  color: widget.tool.color.withValues(alpha: 0.3),
                  blurRadius: 20, spreadRadius: 2,
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8, offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: widget.tool.color.withValues(alpha: 0.12),
                    border: Border.all(
                        color: widget.tool.color.withValues(alpha: 0.3)),
                  ),
                  child: Icon(widget.tool.icon,
                      color: widget.tool.color, size: 22),
                ),
                const Spacer(),
                Text(widget.tool.name, style: AppTheme.labelBold(size: 15)),
                const SizedBox(height: 3),
                Text(widget.tool.desc,
                    style: AppTheme.bodyMedium(size: 11),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Open →',
                        style: AppTheme.labelBold(
                            color: widget.tool.color, size: 11)),
                    const SizedBox(width: 4),
                    Icon(Icons.open_in_new,
                        color: widget.tool.color, size: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 500.ms)
        .scale(
          begin: const Offset(0.9, 0.9), end: const Offset(1, 1),
          delay: Duration(milliseconds: widget.delay), duration: 400.ms);
  }
}
