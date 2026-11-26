import 'package:flutter/material.dart';

/// A high-performance lazy-loading IndexedStack that builds and mounts
/// child tab widgets only when they are first activated. Once built,
/// the widgets remain alive in the element tree, preserving scroll offsets,
/// animation controllers, and cubit subscriptions with zero reload delay (0ms).
class LazyIndexedStack extends StatefulWidget {
  final int index;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;

  const LazyIndexedStack({
    super.key,
    required this.index,
    required this.itemCount,
    required this.itemBuilder,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
  });

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final List<Widget?> _loadedChildren;

  @override
  void initState() {
    super.initState();
    _loadedChildren = List<Widget?>.filled(widget.itemCount, null);
    _activateIndex(widget.index);
  }

  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount != oldWidget.itemCount) {
      final oldList = List<Widget?>.from(_loadedChildren);
      _loadedChildren = List<Widget?>.filled(widget.itemCount, null);
      for (int i = 0; i < widget.itemCount && i < oldList.length; i++) {
        _loadedChildren[i] = oldList[i];
      }
    }
    _activateIndex(widget.index);
  }

  void _activateIndex(int index) {
    if (index >= 0 &&
        index < widget.itemCount &&
        _loadedChildren[index] == null) {
      _loadedChildren[index] = widget.itemBuilder(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    _activateIndex(widget.index);

    return IndexedStack(
      index: widget.index >= 0 && widget.index < widget.itemCount
          ? widget.index
          : 0,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: List.generate(
        widget.itemCount,
        (i) => _loadedChildren[i] ?? const SizedBox.shrink(),
      ),
    );
  }
}
