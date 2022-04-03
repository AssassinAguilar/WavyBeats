import 'package:flutter/material.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';
import 'package:wavy_beats/widgets/favourite_icon.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({Key? key}) : super(key: key);

  static void reload(BuildContext context) =>
      context.findAncestorStateOfType<_ControlButtonsState>()?.reload();

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  Key key = UniqueKey();

  void reload() => setState(() => key = UniqueKey());

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    audioHandler?.playbackState
        .map((state) => state.playing)
        .distinct()
        .listen((playing) {
      if (playing) {
        if (mounted) _iconAnimationController.reverse();
      } else {
        if (mounted) _iconAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: defaultValue * 2.5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async => await audioHandler
                      ?.skipToPrevious()
                      .whenComplete(() => FavouriteIcon.reload(context)),
                  icon: Icon(Icons.skip_previous_rounded,
                      color: Theme.of(context).iconTheme.color),
                  tooltip: "Play Previous",
                  iconSize: 30),
              StreamBuilder<Duration>(
                stream: audioHandler?.playbackState
                    .map((state) => state.updatePosition)
                    .distinct(),
                builder: (context, snapshot) => IconButton(
                    onPressed: () {
                      Duration _newDur = Duration(
                          hours: snapshot.data!.inHours,
                          minutes: snapshot.data!.inMinutes.remainder(60),
                          seconds: snapshot.data!.inSeconds.remainder(60));
                      if (snapshot.data!.inSeconds >
                          Preferences.getSkipInterval()) {
                        _newDur -=
                            Duration(seconds: Preferences.getSkipInterval());
                      } else {
                        _newDur = const Duration(seconds: 0);
                      }
                      audioHandler?.seek(_newDur);
                    },
                    icon: Icon({
                      5: Icons.replay_5_rounded,
                      10: Icons.replay_10_rounded,
                      30: Icons.replay_30_rounded
                    }[Preferences.getSkipInterval()]),
                    tooltip: "Rewind ${Preferences.getSkipInterval()} Seconds",
                    iconSize: 40),
              ),
              StreamBuilder<bool>(
                  stream: audioHandler!.playbackState
                      .map((state) => state.playing)
                      .distinct(),
                  builder: (context, snapshot) {
                    return IconButton(
                        onPressed: () {
                          if (snapshot.data == true) {
                            audioHandler?.pause();
                          } else {
                            audioHandler?.play();
                          }
                        },
                        icon: AnimatedIcon(
                            icon: AnimatedIcons.pause_play,
                            progress: _iconAnimationController),
                        tooltip: snapshot.data == true ? "Pause" : "Play",
                        iconSize: 55);
                  }),
              StreamBuilder<Duration>(
                stream: audioHandler?.playbackState
                    .map((state) => state.updatePosition)
                    .distinct(),
                builder: (context, snapshot) => IconButton(
                    onPressed: () {
                      Duration _newDur = Duration(
                          hours: snapshot.data!.inHours,
                          minutes: snapshot.data!.inMinutes.remainder(60),
                          seconds: snapshot.data!.inSeconds.remainder(60));
                      if (snapshot.data!.inSeconds >
                          snapshot.data!.inSeconds -
                              Preferences.getSkipInterval()) {
                        _newDur +=
                            Duration(seconds: Preferences.getSkipInterval());
                      } else {
                        audioHandler?.skipToNext();
                      }
                      audioHandler?.seek(_newDur);
                    },
                    icon: Icon({
                      5: Icons.forward_5_rounded,
                      10: Icons.forward_10_rounded,
                      30: Icons.forward_30_rounded
                    }[Preferences.getSkipInterval()]),
                    tooltip: "Forward ${Preferences.getSkipInterval()} Seconds",
                    iconSize: 40),
              ),
              IconButton(
                  onPressed: () async => await audioHandler
                      ?.skipToNext()
                      .whenComplete(() => FavouriteIcon.reload(context)),
                  icon: Icon(Icons.skip_next_rounded,
                      color: Theme.of(context).iconTheme.color),
                  tooltip: "Play Next",
                  iconSize: 30),
            ]));
  }
}
