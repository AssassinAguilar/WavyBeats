import 'package:flutter/material.dart';
import 'package:wavy_beats/utilities/helpers.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultValue * 2),
        child: const Divider(thickness: 1.2));
  }
}