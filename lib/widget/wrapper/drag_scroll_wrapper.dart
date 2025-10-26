import 'package:flutter/material.dart';

class DragScrollWrapper extends StatefulWidget {
  final Widget child;
  final Axis scrollDirection;

  const DragScrollWrapper({
    super.key,
    required this.child,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  State<DragScrollWrapper> createState() => _DragScrollWrapperState();
}

class _DragScrollWrapperState extends State<DragScrollWrapper> {
  final ScrollController _controller = ScrollController();
  Offset? _lastPosition;
  bool _isDragging = false;

  void _onPointerMove(PointerMoveEvent event) {
    if (_lastPosition != null && _isDragging) {
      final delta = event.position - _lastPosition!;
      _lastPosition = event.position;

      if (widget.scrollDirection == Axis.horizontal) {
        _controller.jumpTo(
          (_controller.offset - delta.dx).clamp(
            _controller.position.minScrollExtent,
            _controller.position.maxScrollExtent,
          ),
        );
      } else {
        _controller.jumpTo(
          (_controller.offset - delta.dy).clamp(
            _controller.position.minScrollExtent,
            _controller.position.maxScrollExtent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _isDragging = true;
        _lastPosition = event.position;
      },
      onPointerMove: _onPointerMove,
      onPointerUp: (_) {
        _isDragging = false;
        _lastPosition = null;
      },
      child: SingleChildScrollView(
        controller: _controller,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: widget.scrollDirection,
        child: widget.child,
      ),
    );
  }
}
