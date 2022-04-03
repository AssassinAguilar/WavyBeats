import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wavy_beats/theme/custom.dart';
import 'package:wavy_beats/utilities/helpers.dart';

class CustomImage extends StatelessWidget {
  final String filePath;
  const CustomImage(this.filePath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File(filePath),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        errorBuilder: (context, error, stackTrace) => Image.asset(
            "assets/Cover.png",
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            isAntiAlias: true));
  }
}

class CoverImage extends StatelessWidget {
  final String filePath;
  final double height;
  final double width;
  final bool shouldDecorate;
  const CoverImage(this.filePath, this.height, this.width,
      {Key? key, this.shouldDecorate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: shouldDecorate
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(defaultValue),
                boxShadow: CustomTheme.boxShadow)
            : const BoxDecoration(),
        child: Image.file(File(filePath),
            height: height,
            width: width,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            errorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/Cover.png",
                height: height,
                width: width,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                isAntiAlias: true)));
  }
}
