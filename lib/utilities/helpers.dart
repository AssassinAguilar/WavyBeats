import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wavy_beats/theme/custom.dart';

late AudioHandler? audioHandler;

const double defaultValue = 10;
const List<String> modeNames = ["Light", "Dark", "System"];

final List<Map?> songs = [];

ValueNotifier<bool> playerHasPrev = ValueNotifier<bool>(false);
ValueNotifier<bool> playerHasNext = ValueNotifier<bool>(false);
ValueNotifier<bool> isFavourite = ValueNotifier<bool>(false);

List<List> themeCode = [
  [CustomTheme.red, CustomTheme.redAccent, "Red"],
  [CustomTheme.blue, CustomTheme.blueAccent, "Blue"],
  [CustomTheme.green, CustomTheme.greenAccent, "Green"],
  [CustomTheme.purple, CustomTheme.purpleAccent, "Purple"]
];
List<List> loopModes = [
  [
    AudioServiceRepeatMode.none,
    LoopMode.off,
    const Icon(Icons.repeat_rounded),
    "Loop All"
  ],
  [
    AudioServiceRepeatMode.all,
    LoopMode.all,
    const Icon(Icons.repeat_rounded),
    "Loop One"
  ],
  [
    AudioServiceRepeatMode.one,
    LoopMode.one,
    const Icon(Icons.repeat_one_rounded),
    "Loop Off"
  ]
];
