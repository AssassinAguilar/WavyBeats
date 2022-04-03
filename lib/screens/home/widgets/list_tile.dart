import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wavy_beats/screens/home/pages/favourites/favourites_model.dart';
import 'package:wavy_beats/screens/player/player.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';
import 'package:wavy_beats/widgets/animated_text.dart';
import 'package:wavy_beats/widgets/favourite_icon.dart';
import 'package:wavy_beats/widgets/image.dart';

class CurrentPlayingState {
  final MediaItem? mediaItem;
  final bool isPlaying;
  final AudioProcessingState processingState;
  CurrentPlayingState(this.mediaItem, this.isPlaying, this.processingState);
}

class CustomTile extends StatelessWidget {
  final bool isFavourites;
  final int index;
  final int length;
  final List tracks;
  CustomTile(this.isFavourites, this.index, {Key? key})
      : length =
            isFavourites ? favouriteTracks.favouriteSongs.length : songs.length,
        tracks = isFavourites ? favouriteTracks.favouriteSongs : songs,
        super(key: key);

  Stream<CurrentPlayingState> get _currentPlayingStateStream =>
      Rx.combineLatest3<MediaItem?, bool, AudioProcessingState,
              CurrentPlayingState>(
          audioHandler!.mediaItem,
          audioHandler!.playbackState.map((state) => state.playing).distinct(),
          audioHandler!.playbackState
              .map((state) => state.processingState)
              .distinct(),
          (mediaItem, isPlaying, processingState) =>
              CurrentPlayingState(mediaItem, isPlaying, processingState));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentPlayingState>(
        stream: _currentPlayingStateStream,
        builder: (context, snapshot) {
          return ListTile(
              leading: CoverImage(tracks[index]["artWork"], 50, 50,
                  shouldDecorate: true),
              title: AnimatedText(tracks[index]["title"],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: (tracks[index]["path"] == snapshot.data?.mediaItem?.id && snapshot.data?.mediaItem?.extras?["isFavourite"] == isFavourites && snapshot.data?.processingState == AudioProcessingState.ready)
                          ? themeManager.primaryAccentColor
                          : Theme.of(context).listTileTheme.textColor,
                      fontWeight:
                          (tracks[index]["path"] == snapshot.data?.mediaItem?.id && snapshot.data?.mediaItem?.extras?["isFavourite"] == isFavourites && snapshot.data?.processingState == AudioProcessingState.ready)
                              ? FontWeight.bold
                              : FontWeight.normal)),
              subtitle: AnimatedText(tracks[index]["artist"],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: (tracks[index]["path"] == snapshot.data?.mediaItem?.id &&
                              snapshot.data?.mediaItem?.extras?["isFavourite"] ==
                                  isFavourites &&
                              snapshot.data?.processingState == AudioProcessingState.ready)
                          ? themeManager.primaryAccentColor
                          : Theme.of(context).listTileTheme.textColor!.withOpacity(0.7),
                      fontWeight: (tracks[index]["path"] == snapshot.data?.mediaItem?.id && snapshot.data?.mediaItem?.extras?["isFavourite"] == isFavourites && snapshot.data?.processingState == AudioProcessingState.ready) ? FontWeight.normal : FontWeight.w300)),
              trailing: (tracks[index]["path"] == snapshot.data?.mediaItem?.id && snapshot.data?.mediaItem?.extras?["isFavourite"] == isFavourites && snapshot.data?.isPlaying == true && snapshot.data?.processingState == AudioProcessingState.ready) ? Text("Now Playing", style: TextStyle(color: themeManager.primaryAccentColor.withOpacity(0.95), fontWeight: FontWeight.w600, letterSpacing: 0.5)) : FavouriteIcon(songPath: tracks[index]["path"]),
              onTap: () {
                if (tracks[index]["path"] == snapshot.data?.mediaItem?.id &&
                    snapshot.data?.mediaItem?.extras?["isFavourite"] ==
                        isFavourites &&
                    snapshot.data?.processingState !=
                        AudioProcessingState.idle) {
                  Navigator.of(context).pop();
                } else {
                  audioHandler
                      ?.setRepeatMode(loopModes[Preferences.getLoopMode()][0]);
                  audioHandler?.setShuffleMode(Preferences.getIsShuffling()
                      ? AudioServiceShuffleMode.all
                      : AudioServiceShuffleMode.none);
                  audioHandler?.customAction(
                      "setSpeed", {"speed": Preferences.getPlaySpeed()});
                  audioHandler?.customAction("setSkipSilence",
                      {"isSilenceSkipped": Preferences.getIsSilenceSkipped()});
                  audioHandler?.customAction("setVolume");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PlayerPage(
                          songIndex: index, isFavourites: isFavourites)));
                }
              });
        });
  }
}
