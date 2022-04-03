import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wavy_beats/screens/home/pages/favourites/favourites_model.dart';
import 'package:wavy_beats/screens/player/player.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';

class TopBar extends StatelessWidget {
  final bool isFavourites;
  final int length;
  final List tracks;
  TopBar(this.isFavourites, {Key? key})
      : length =
            isFavourites ? favouriteTracks.favouriteSongs.length : songs.length,
        tracks = isFavourites ? favouriteTracks.favouriteSongs : songs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultValue * 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(length.toString() + " songs",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontSize: 15)),
                  Row(children: [
                    IconButton(
                        icon: const Icon(CupertinoIcons.shuffle),
                        constraints:
                            BoxConstraints.tight(const Size.fromWidth(30)),
                        iconSize: 20,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          Preferences.setIsShuffling(true);
                          audioHandler?.setShuffleMode(
                              Preferences.getIsShuffling()
                                  ? AudioServiceShuffleMode.all
                                  : AudioServiceShuffleMode.none);
                          audioHandler?.setRepeatMode(
                              loopModes[Preferences.getLoopMode()][0]);
                          audioHandler?.customAction("setSpeed",
                              {"speed": Preferences.getPlaySpeed()});
                          audioHandler?.customAction("setSkipSilence", {
                            "isSilenceSkipped":
                                Preferences.getIsSilenceSkipped()
                          });
                          audioHandler?.customAction("setVolume");
                          final int index = Random().nextInt(length);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => PlayerPage(
                                  songIndex: index,
                                  isFavourites: isFavourites)));
                        }),
                    IconButton(
                        icon: const Icon(Icons.play_arrow_rounded),
                        constraints:
                            BoxConstraints.tight(const Size.fromWidth(30)),
                        iconSize: 25,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          audioHandler?.setRepeatMode(
                              loopModes[Preferences.getLoopMode()][0]);
                          audioHandler?.setShuffleMode(
                              Preferences.getIsShuffling()
                                  ? AudioServiceShuffleMode.all
                                  : AudioServiceShuffleMode.none);
                          audioHandler?.customAction("setSpeed",
                              {"speed": Preferences.getPlaySpeed()});
                          audioHandler?.customAction("setSkipSilence", {
                            "isSilenceSkipped":
                                Preferences.getIsSilenceSkipped()
                          });
                          audioHandler?.customAction("setVolume");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => PlayerPage(
                                  songIndex: 0, isFavourites: isFavourites)));
                        })
                  ])
                ])));
  }
}
