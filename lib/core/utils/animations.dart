import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shared motion language for the app: subtle fade + slight upward slide.
///
/// Keeping every entrance animation in one place ensures the UI feels
/// consistent and minimalist instead of each screen inventing its own curve.
extension AppEntrance on Widget {
  /// Fades the widget in while it gently slides up.
  ///
  /// [order] staggers a group of widgets (e.g. the cards in a list) so they
  /// appear one after another. Pass the item index.
  Widget entrance({int order = 0}) {
    return animate(delay: (60 * order).ms)
        .fadeIn(duration: 320.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 320.ms, curve: Curves.easeOutCubic);
  }

  /// Quick, unobtrusive fade for list items. Short enough to stay pleasant
  /// even if it replays as the widget is recycled while scrolling.
  Widget softFade() => animate().fadeIn(duration: 220.ms, curve: Curves.easeOut);
}
