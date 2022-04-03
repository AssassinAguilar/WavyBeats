import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';

class CustomAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);
  Timer? _sleepTimer;

  CustomAudioHandler() {
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
        androidWillPauseWhenDucked: true,
      ));
    });
    _loadEmptyPlaylist();
    Rx.combineLatest5<int?, List<MediaItem>, bool, List<int>?, Duration?,
                MediaItem?>(
            _player.currentIndexStream,
            queue,
            _player.shuffleModeEnabledStream,
            _player.shuffleIndicesStream,
            _player.durationStream,
            (index, queue, shuffleModeEnabled, shuffleIndices, duration) {
      final queueIndex =
          getQueueIndex(index, shuffleModeEnabled, shuffleIndices);
      return (queueIndex != null && queueIndex < queue.length)
          ? queue[queueIndex].copyWith(duration: duration)
          : null;
    })
        .debounceTime(const Duration(milliseconds: 750))
        .whereType<MediaItem>()
        .distinct()
        .listen(mediaItem.add);
    _player.playbackEventStream.listen(_notifyAudioHandlerAboutPlaybackEvents);
    _player.shuffleModeEnabledStream.listen((enabled) =>
        _notifyAudioHandlerAboutPlaybackEvents(_player.playbackEvent));
    _player.loopModeStream.listen((loopMode) =>
        _notifyAudioHandlerAboutPlaybackEvents(_player.playbackEvent));
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) stop();
    });
    _effectiveSequence
        .map((sequence) =>
            sequence.map((source) => source.tag as MediaItem).toList())
        .pipe(queue);
  }

  Future<void> _loadEmptyPlaylist() async =>
      await _player.setAudioSource(_playlist);

  Stream<List<IndexedAudioSource>> get _effectiveSequence => Rx.combineLatest3<
              List<IndexedAudioSource>?,
              List<int>?,
              bool,
              List<IndexedAudioSource>?>(_player.sequenceStream,
          _player.shuffleIndicesStream, _player.shuffleModeEnabledStream,
          (sequence, shuffleIndices, shuffleModeEnabled) {
        if (sequence == null) return [];
        if (!shuffleModeEnabled) return sequence;
        if (shuffleIndices == null) return null;
        if (shuffleIndices.length != sequence.length) return null;
        return shuffleIndices.map((i) => sequence[i]).toList();
      }).whereType<List<IndexedAudioSource>>();

  int? getQueueIndex(
      int? currentIndex, bool shuffleModeEnabled, List<int>? shuffleIndices) {
    final effectiveIndices = _player.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (shuffleModeEnabled &&
            ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == "setSpeed") {
      Preferences.setPlaySpeed(extras!["speed"]);
      await _player.setSpeed(Preferences.getPlaySpeed());
      playbackState.add(playbackState.value.copyWith(
        speed: _player.speed,
      ));
    } else if (name == "skipSilence") {
      Preferences.setIsSilenceSkipped(extras!["IsSilenceSkipped"]);
      await _player.setSkipSilenceEnabled(Preferences.getIsSilenceSkipped());
    } else if (name == "setVolume") {
      await _player.setVolume(1);
    } else if (name == "dispose") {
      await _player.dispose();
    } else if (name == "sleepTimer") {
      _sleepTimer?.cancel();
      if (extras!["time"] != null &&
          extras["time"].runtimeType == int &&
          extras["time"] > 0 as bool) {
        _sleepTimer =
            Timer(Duration(minutes: extras["time"] as int), () => stop());
      }
    }
  }

  @override
  Future<void> play() async => await _player.play();

  @override
  Future<void> pause() async => await _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await playbackState.firstWhere(
        (state) => state.processingState == AudioProcessingState.idle);
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    await _player.play();
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
    await _player.play();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
    await _player.play();
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;
    if (enabled) await _player.shuffle();
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));
    await _player.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
    await _player.setLoopMode(LoopMode.values[repeatMode.index]);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.clear();
    _playlist.addAll(audioSource.toList());
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) =>
      AudioSource.uri(Uri.file(mediaItem.id, windows: false), tag: mediaItem);

  void _notifyAudioHandlerAboutPlaybackEvents(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
        controls: [
          if (_player.hasPrevious) MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
          if (_player.hasNext) MediaControl.skipToNext,
          MediaControl.stop
        ],
        systemActions: const {
          MediaAction.seek
        },
        androidCompactActionIndices: [
          if (_player.hasPrevious) 0 else if (_player.hasNext) 2 else 0,
          if (_player.hasPrevious) 1 else if (_player.hasNext) 0,
          if (_player.hasPrevious) 2 else if (_player.hasNext) 1
        ],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed
        }[_player.processingState]!,
        repeatMode: loopModes[Preferences.getLoopMode()][0],
        shuffleMode: (Preferences.getIsShuffling())
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: Preferences.getPlaySpeed(),
        queueIndex: event.currentIndex));
  }
}
