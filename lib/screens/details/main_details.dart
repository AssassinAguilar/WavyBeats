import 'package:flutter/material.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/widgets/animated_text.dart';
import 'package:wavy_beats/widgets/image.dart';

class MainDetails extends StatelessWidget {
  final Map? song;
  const MainDetails(this.song, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      CoverImage(song?["artWork"], MediaQuery.of(context).size.height / 3,
          MediaQuery.of(context).size.width / 1.5, shouldDecorate: true),
      const SizedBox(height: defaultValue),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultValue * 2.5),
        child: AnimatedText(song?["title"],
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: themeManager.primaryColor)),
      ),
      const SizedBox(height: defaultValue / 5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultValue * 2.5),
        child: AnimatedText(song?["artist"],
            style: Theme.of(context).textTheme.headline3),
      )
    ]);
  }
}
