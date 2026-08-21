import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'nav_bar.dart';

class SiteScaffold extends StatefulWidget {
  const SiteScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<SiteScaffold> createState() => _SiteScaffoldState();
}

class _SiteScaffoldState extends State<SiteScaffold> {
  bool _menuOpen = false;
  double _scrollOpacity = 0.0;

  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);
  void _closeMenu() {
    if (_menuOpen) setState(() => _menuOpen = false);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification ||
        notification is ScrollStartNotification) {
      final offset = notification.metrics.pixels;
      final opacity = (offset / 40.0).clamp(0.0, 1.0);
      if ((opacity - _scrollOpacity).abs() > 0.01) {
        setState(() => _scrollOpacity = opacity);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kaizenCream,
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: Stack(
          children: [
            widget.child,
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: AppSpacing.navBarHeight,
              child: NavBar(
                scrollOpacity: _scrollOpacity,
                menuOpen: _menuOpen,
                onMenuToggle: _toggleMenu,
              ),
            ),
            if (_menuOpen)
              Positioned.fill(
                child: MobileMenuOverlay(onClose: _closeMenu),
              ),
          ],
        ),
      ),
    );
  }
}
