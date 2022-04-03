import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';

class SeekBar extends StatefulWidget {
  final Duration? duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  const SeekBar(
      {required this.duration,
      required this.position,
      this.onChanged,
      this.onChangeEnd,
      Key? key})
      : super(key: key);

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final value = min(
      _dragValue ?? widget.position.inMilliseconds.toDouble(),
      widget.duration!.inMilliseconds.toDouble(),
    );
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Slider.adaptive(
        min: 0.0,
        value: value,
        max: widget.duration!.inMilliseconds.toDouble(),
        inactiveColor: themeManager.primaryColor.withOpacity(0.2),
        onChanged: (value) {
          if (!_dragging) {
            _dragging = true;
          }
          setState(() {
            _dragValue = value;
          });
          widget.onChanged?.call(Duration(milliseconds: value.round()));
        },
        onChangeEnd: (value) {
          widget.onChangeEnd?.call(Duration(milliseconds: value.round()));
          _dragging = false;
        });
  }
}
