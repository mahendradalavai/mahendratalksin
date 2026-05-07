import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'about_screen.dart';
import 'tools_screen.dart';
import 'contact_screen.dart';

/// ─────────────────────────────────────────────
///  HomeShell — Bottom navigation wrapper
///  3 tabs: About · Tools · Contact
/// ─────────────────────────────────────────────
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final PageController _pageCtrl;
  late AnimationController _barAnim;

  final List<Widget> _pages = const [
    AboutScreen(),
    ToolsScreen(),
    ContactScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _barAnim = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _barAnim.dispose();
    super.dispose();
  }

  void _onTabTap(int idx) {
    if (idx == _currentIndex) return;
    setState(() => _currentIndex = idx);
    _pageCtrl.animateToPage(
      idx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: PageView(
        controller: _pageCtrl,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: _pages,
      ),
      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), end: Offset.zero,
        ).animate(CurvedAnimation(parent: _barAnim, curve: Curves.easeOut)),
        child: _buildNavBar(),
      ),
    );
  }

  static const _navItems = [
    (icon: Icons.person_outline_rounded,
     activeIcon: Icons.person_rounded,
     label: 'About'),
    (icon: Icons.build_outlined,
     activeIcon: Icons.build_rounded,
     label: 'Tools'),
    (icon: Icons.mail_outline_rounded,
     activeIcon: Icons.mail_rounded,
     label: 'Contact'),
  ];

  Widget _buildNavBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: _navItems.asMap().entries.map((e) {
          final idx      = e.key;
          final item     = e.value;
          final selected = _currentIndex == idx;

          return Expanded(
            child: GestureDetector(
              onTap: () => _onTabTap(idx),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Active indicator line
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: selected ? 24 : 0,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  // Icon
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      selected ? item.activeIcon : item.icon,
                      key: ValueKey(selected),
                      color: selected ? AppTheme.accent : AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppTheme.accent : AppTheme.textSecondary,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
