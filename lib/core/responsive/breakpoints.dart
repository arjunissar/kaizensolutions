import 'package:flutter/widgets.dart';

abstract final class Breakpoints {
  static const double mobile = 640;
  static const double tablet = 1024;
}

/// Manual `\n` breaks in headline/quote copy are art-directed for one
/// specific width. At any other width they combine with natural wrapping
/// into ugly orphan lines (a lone "your" or "becoming" on its own line) —
/// see the mobile screenshots that motivated this. Call `.breaks(keep: ...)`
/// with whichever breakpoint check the surrounding widget already uses, so
/// the forced break only survives at the width it was designed for.
extension BreakawareString on String {
  String breaks({required bool keep}) => keep ? this : replaceAll('\n', ' ');
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
