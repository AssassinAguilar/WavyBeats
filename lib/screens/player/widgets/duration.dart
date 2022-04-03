import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:wavy_beats/utilities/helpers.dart';

class Durations extends StatelessWidget {
  const Durations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultValue * 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          StreamBuilder<Duration>(
            stream: AudioService.position,
            builder: (context, snapshot) => Text(
                snapshot.hasData
                    ? snapshot.data.toString().split(".")[0]
                    : "0:00:00",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          StreamBuilder<MediaItem?>(
              stream: audioHandler?.mediaItem,
              builder: (context, snapshot) {
                return Text(
                    snapshot.hasData
                        ? (snapshot.data?.duration).toString().split(".")[0]
                        : "0:00:00",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w500));
              })
        ]));
  }
}
