import 'package:flutter/material.dart';

class CircularCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const CircularCheckbox({this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
