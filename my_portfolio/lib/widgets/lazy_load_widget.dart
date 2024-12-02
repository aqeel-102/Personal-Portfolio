import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LazyLoadWidget extends StatefulWidget {
  final Widget child;
  final bool Function() shouldLoad;
  final VoidCallback onVisible;

  const LazyLoadWidget({
    super.key,
    required this.child,
    required this.shouldLoad,
    required this.onVisible,
  });

  @override
  State<LazyLoadWidget> createState() => _LazyLoadWidgetState();
}

class _LazyLoadWidgetState extends State<LazyLoadWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('lazy-load-${widget.key}'),
      onVisibilityChanged: (visibilityInfo) {
        if (!_isVisible && 
            visibilityInfo.visibleFraction > 0 && 
            widget.shouldLoad()) {
          _isVisible = true;
          widget.onVisible();
        }
      },
      child: widget.child,
    );
  }
} 