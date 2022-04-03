import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wavy_beats/screens/details/list_details.dart';
import 'package:wavy_beats/screens/details/main_details.dart';
import 'package:wavy_beats/utilities/helpers.dart';

class MediaState {
  final bool? isPlaying;
  final AudioProcessingState? processingState;
  MediaState(this.isPlaying, this.processingState);
}

class SongDetails extends StatelessWidget {
  final Map? song;
  final bool isFavourite;
  const SongDetails({Key? key, required this.song, this.isFavourite = false})
      : super(key: key);

  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<bool?, AudioProcessingState?, MediaState>(
          audioHandler!.playbackState.map((state) => state.playing).distinct(),
          audioHandler!.playbackState
              .map((state) => state.processingState)
              .distinct(),
          (isPlaying, processingState) =>
              MediaState(isPlaying, processingState));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<MediaState>(
            stream: _mediaStateStream,
            builder: (context, snapshot) {
              final processingState =
                  snapshot.data?.processingState ?? AudioProcessingState.idle;
              final playing = snapshot.data?.isPlaying ?? true;
              if (processingState == AudioProcessingState.idle &&
                  playing == false) {
                WidgetsBinding.instance!
                    .addPostFrameCallback((_) => Navigator.of(context).pop());
              }
              return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        splashRadius: 25,
                        tooltip: "Go Back",
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                  body: Column(children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 2 - 60,
                        width: MediaQuery.of(context).size.width,
                        child: MainDetails(song)),
                    Expanded(child: ListDetails(song))
                  ]));
            }));
  }
}
