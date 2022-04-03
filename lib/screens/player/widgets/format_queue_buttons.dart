import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';
import 'package:wavy_beats/widgets/favourite_icon.dart';

class FormatQueueButton extends StatefulWidget {
  final int songIndex;
  final bool isFavourites;
  const FormatQueueButton(this.songIndex, this.isFavourites, {Key? key})
      : super(key: key);

  @override
  State<FormatQueueButton> createState() => _FormatQueueButtonState();
}

class _FormatQueueButtonState extends State<FormatQueueButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<AudioServiceShuffleMode>(
              stream: audioHandler?.playbackState
                  .map((state) => state.shuffleMode)
                  .distinct(),
              builder: (context, snapshot) => Tooltip(
                    message: Preferences.getIsShuffling()
                        ? "Shuffle Off"
                        : "Shuffle On",
                    child: TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () async {
                          Preferences.setIsShuffling(
                              !(Preferences.getIsShuffling()));
                          await audioHandler?.setShuffleMode(
                              Preferences.getIsShuffling()
                                  ? AudioServiceShuffleMode.all
                                  : AudioServiceShuffleMode.none);
                          setState(() {});
                        },
                        child: Stack(alignment: Alignment.center, children: [
                          Icon(CupertinoIcons.shuffle,
                              size: 30,
                              color: Preferences.getIsShuffling()
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context)
                                      .iconTheme
                                      .color!
                                      .withOpacity(0.7)),
                          Transform.rotate(
                              angle: 0.5,
                              child: Container(
                                  height: 45,
                                  width: 3,
                                  decoration: BoxDecoration(
                                      color: Preferences.getIsShuffling()
                                          ? Colors.transparent
                                          : Theme.of(context)
                                              .iconTheme
                                              .color!
                                              .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(50))))
                        ])),
                  )),
          StreamBuilder<MediaItem?>(
              stream: audioHandler!.mediaItem,
              builder: (context, snapshot) {
                final path = snapshot.data?.id ?? "";
                return FavouriteIcon(songPath: path, size: 45);
              }),
          IconButton(
              icon: loopModes[Preferences.getLoopMode()][2],
              tooltip: loopModes[Preferences.getLoopMode()][3],
              color: Preferences.getLoopMode() == 0
                  ? Theme.of(context).iconTheme.color!.withOpacity(0.7)
                  : Theme.of(context).iconTheme.color,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                Preferences.setLoopMode(
                    (Preferences.getLoopMode() + 1) % loopModes.length);
                await audioHandler
                    ?.setRepeatMode(loopModes[Preferences.getLoopMode()][0]);
                setState(() {});
              },
              iconSize: 30)
        ]);
  }
}
