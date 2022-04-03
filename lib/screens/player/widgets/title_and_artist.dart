import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/widgets/animated_text.dart';

class TitleAndArtist extends StatelessWidget {
  final bool title;
  const TitleAndArtist(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultValue * 2.5),
        child: StreamBuilder<MediaItem?>(
            stream: audioHandler?.mediaItem,
            builder: (context, snapshot) => AnimatedText(
                title
                    ? (snapshot.data?.title).toString()
                    : (snapshot.data?.artist).toString(),
                style: title
                    ? Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 22, color: themeManager.primaryColor)
                    : Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 18))));
  }
}
