import 'package:flutter/widgets.dart';

abstract final class Breakpoints {
  static const double mobile = 640;
  static const double tablet = 1024;
}

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder tablet;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > Breakpoints.tablet) {
          return desktop(context);
        } else if (constraints.maxWidth >= Breakpoints.mobile) {
          return tablet(context);
        } else {
          return mobile(context);
        }
      },
    );
  }
}
