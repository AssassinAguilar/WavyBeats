import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wavy_beats/screens/home/home.dart';
import 'package:wavy_beats/screens/home/pages/favourites/favourites_model.dart';
import 'package:wavy_beats/screens/player/widgets/app_bar.dart';
import 'package:wavy_beats/screens/player/widgets/control_buttons.dart';
import 'package:wavy_beats/screens/player/widgets/duration.dart';
import 'package:wavy_beats/screens/player/widgets/format_queue_buttons.dart';
import 'package:wavy_beats/screens/player/widgets/seek_bar.dart';
import 'package:wavy_beats/screens/player/widgets/title_and_artist.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/utilities/helpers.dart';

class MediaState {
  final bool? isPlaying;
  final AudioProcessingState? processingState;
  MediaState(this.isPlaying, this.processingState);
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

class PlayerPage extends StatefulWidget {
  final int songIndex;
  final bool isFavourites;
  const PlayerPage(
      {Key? key, required this.songIndex, this.isFavourites = false})
      : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<bool?, AudioProcessingState?, MediaState>(
          audioHandler!.playbackState.map((state) => state.playing).distinct(),
          audioHandler!.playbackState
              .map((state) => state.processingState)
              .distinct(),
          (isPlaying, processingState) =>
              MediaState(isPlaying, processingState));

  Stream<Duration?> get _durationStream =>
      audioHandler!.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest2<Duration, Duration?, PositionData>(
          AudioService.position,
          _durationStream,
          (position, duration) =>
              PositionData(position, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    audioHandler?.stop();
    final List<Map<String, dynamic>> _playlist = [];
    _playlist.clear();
    _playlist.addAll(widget.isFavourites
        ? List.generate(
            favouriteTracks.favouriteSongs.length,
            (index) => {
                  "id": favouriteTracks.favouriteSongs[index]["path"],
                  "title": favouriteTracks.favouriteSongs[index]["title"],
                  "album": favouriteTracks.favouriteSongs[index]["album"],
                  "artist": favouriteTracks.favouriteSongs[index]["artist"],
                  "artWork": favouriteTracks.favouriteSongs[index]["artWork"],
                  "lyrics": favouriteTracks.favouriteSongs[index]["lyrics"],
                  "isFavourite": true
                })
        : List.generate(
            songs.length,
            (index) => {
                  "id": songs[index]?["path"],
                  "title": songs[index]?["title"],
                  "album": songs[index]?["album"],
                  "artist": songs[index]?["artist"],
                  "artWork": songs[index]?["artWork"],
                  "lyrics": songs[index]?["lyrics"],
                  "isFavourite": false
                }));
    audioHandler?.queue.value.clear();
    await audioHandler?.addQueueItems(_playlist
        .map((song) => MediaItem(
                id: song["id"],
                title: song["title"] ?? "Undefined",
                album: song["album"] ?? "Unknown",
                artist: song["artist"] ?? "Unknown",
                artUri: Uri.file(song["artWork"], windows: false),
                extras: {
                  "lyrics": song["lyrics"] ?? "",
                  "isFavourite": song["isFavourite"]
                }))
        .toList());
    await audioHandler?.skipToQueueItem(widget.songIndex);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: StreamBuilder<MediaState>(
            stream: _mediaStateStream,
            builder: (context, snapshot) {
              final processingState =
                  snapshot.data?.processingState ?? AudioProcessingState.idle;
              final playing = snapshot.data?.isPlaying ?? true;
              if (processingState == AudioProcessingState.idle &&
                  playing == false) {
                WidgetsBinding.instance!
                    .addPostFrameCallback((_) => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => WillPopScope(
                    child: MyHome(index: widget.isFavourites ? 0 : 1),
                    onWillPop: () async => false))));
              }
              if (processingState == AudioProcessingState.ready ||
                  processingState == AudioProcessingState.buffering) {
                return Scaffold(
                    appBar: PreferredSize(
                        preferredSize: Size.fromHeight(
                            MediaQuery.of(context).size.height / 1.75),
                        child: StreamBuilder<MediaItem?>(
                            stream: audioHandler?.mediaItem,
                            builder: (context, snapshot) => PlayerPageAppBar(
                                title: (snapshot.data?.album).toString(),
                                image: (snapshot.data?.artUri?.toFilePath())
                                    .toString(),
                                lyrics:
                                    (snapshot.data?.extras?["lyrics"]).toString(),
                                isFavourite: widget.isFavourites,
                                pageIndex: widget.isFavourites ? 0 : 1))),
                    body: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const TitleAndArtist(true),
                          const SizedBox(height: defaultValue / 3),
                          const TitleAndArtist(false),
                          const SizedBox(height: defaultValue / 3),
                          FormatQueueButton(
                              widget.songIndex, widget.isFavourites),
                          SizedBox(
                              height: defaultValue * 4.8,
                              child: StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data ??
                                        PositionData(
                                            Duration.zero, Duration.zero);
                                    return SeekBar(
                                        position: positionData.position,
                                        duration: positionData.duration,
                                        onChangeEnd: (newPosition) =>
                                            audioHandler?.seek(newPosition));
                                  })),
                          const Durations(),
                          const ControlButtons()
                        ]));
              }
              return Scaffold(
                  body: Center(
                      child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              themeManager.primaryColor))));
            }),
      ),
      onWillPop: () async => false
    );
  }
}
