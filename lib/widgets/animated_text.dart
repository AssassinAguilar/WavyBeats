import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AnimatedText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign textAlign;

  const AnimatedText(this.data,
      {Key? key, this.style, this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final span = TextSpan(text: data, style: style);

      final tp = TextPainter(
          maxLines: 1,
          textAlign: textAlign,
          textDirection: TextDirection.ltr,
          text: span);

      tp.layout(maxWidth: constraints.maxWidth);

      if (tp.didExceedMaxLines) {
        return SizedBox(
            height: tp.height + 5,
            width: constraints.maxWidth,
            child: Marquee(
                text: '  $data${" " * 30}',
                style: style,
                crossAxisAlignment: CrossAxisAlignment.start));
      } else {
        return SizedBox(
            height: tp.height + 5,
            width: constraints.maxWidth,
            child: Text(data,
                style: style,
                textAlign: textAlign,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade));
      }
    });
  }
}
