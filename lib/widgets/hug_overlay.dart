import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

/// Full-screen overlay that plays the Lottie hug animation.
/// Call [HugOverlay.show] to display; it auto-dismisses after 2.5 seconds.
class HugOverlay {
  static void show(BuildContext context, String targetName) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _HugOverlayWidget(
        targetName: targetName,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);

    // Haptic feedback for warmth
    HapticFeedback.mediumImpact();
  }
}

class _HugOverlayWidget extends StatefulWidget {
  final String targetName;
  final VoidCallback onDismiss;

  const _HugOverlayWidget({
    required this.targetName,
    required this.onDismiss,
  });

  @override
  State<_HugOverlayWidget> createState() => _HugOverlayWidgetState();
}

class _HugOverlayWidgetState extends State<_HugOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Fade in over the first 400ms
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.16, curve: Curves.easeIn),
      ),
    );

    // Fade out over the last 400ms
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.84, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final opacity = _controller.value < 0.84 ? _fadeIn.value : _fadeOut.value;
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Material(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: Lottie.asset(
                  'assets/animations/hug_animation.json',
                  repeat: false,
                  animate: true,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Você mandou um abraço para ${widget.targetName} ❤️',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
