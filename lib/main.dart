import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:wavy_beats/screens/home/home.dart';
import 'package:wavy_beats/services/audio_service.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/theme/modes/dark_mode.dart';
import 'package:wavy_beats/theme/modes/light_mode.dart';
import 'package:wavy_beats/theme/custom.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';
import 'package:wavy_beats/widgets/image.dart';

Future<void> main() async {
  audioHandler = await AudioService.init(
      builder: () => CustomAudioHandler(),
      config: const AudioServiceConfig(
          androidNotificationChannelId: "com.wavy_beats.audio",
          androidNotificationChannelName: "Wavy Beats",
          androidNotificationIcon: "drawable/ic_notification_icon",
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget _homePage;
  @override
  void initState() {
    super.initState();
    Preferences.init();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _homePage = Scaffold(
        backgroundColor: CustomTheme.bgLogoColor,
        body: const Center(child: CoverImage("", 256, 256)));
    isPermissionGranted();
    modeManager.addListener(() => setState(() {}));
    themeManager.addListener(() => setState(() {}));
  }

  Future<void> isPermissionGranted() async {
    (await Permission.storage.isGranted == true)
        ? await listSongs().whenComplete(
            () => setState(() => _homePage = const MyHome(index: 1)))
        : askPermission();
  }

  Future<void> askPermission() async {
    (await Permission.storage.request().isGranted == true)
        ? await listSongs().whenComplete(
            () => setState(() => _homePage = const MyHome(index: 1)))
        : setState(() => _homePage = Scaffold(
            body: Center(
                child: Text("No Song Available To Play",
                    style: TextStyle(
                        color: CustomTheme.black,
                        fontFamily: "Samsung-Sans",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)))));
  }

  Future<void> listSongs() async {
    final Audiotagger _tagger = Audiotagger();
    final info = await DeviceInfoPlugin().androidInfo;
    final List<FileSystemEntity> _files = [];
    songs.clear();
    if (info.version.sdkInt <= 29) {
      for (FileSystemEntity entity in Directory("/storage/emulated/0/")
          .listSync(recursive: true, followLinks: false)) {
        if (entity.parent.path.contains("Android") == false &&
            entity.parent.path.contains("WhatsApp") == false &&
            entity.parent.path.contains("Notifications") == false &&
            entity.parent.path.contains("Ringtones") == false &&
            entity.parent.path.contains(".") == false) {
          if (entity.path.endsWith(".mp3")) {
            if (Preferences.getFolders().contains(entity.parent.path) ==
                false) {
              songs.add(await _tagger.readTagsAsMap(path: entity.path));
              _files.add(entity);
            }
          }
        }
      }
    } else {
      if (await Directory("/storage/emulated/0/bluetooth/").exists()) {
        for (FileSystemEntity entity
            in Directory("/storage/emulated/0/bluetooth/")
                .listSync(recursive: true, followLinks: false)) {
          if (entity.path.endsWith(".mp3")) {
            if (Preferences.getFolders().contains(entity.parent.path) ==
                false) {
              songs.add(await _tagger.readTagsAsMap(path: entity.path));
              _files.add(entity);
            }
          }
        }
      }
      if (await Directory("/storage/emulated/0/Download/").exists()) {
        for (FileSystemEntity entity
            in Directory("/storage/emulated/0/Download/")
                .listSync(recursive: true, followLinks: false)) {
          if (entity.path.endsWith(".mp3")) {
            if (Preferences.getFolders().contains(entity.parent.path) ==
                false) {
              songs.add(await _tagger.readTagsAsMap(path: entity.path));
              _files.add(entity);
            }
          }
        }
      }
      if (await Directory("/storage/emulated/0/Music/").exists()) {
        for (FileSystemEntity entity in Directory("/storage/emulated/0/Music/")
            .listSync(recursive: true, followLinks: false)) {
          if (entity.path.endsWith(".mp3")) {
            if (Preferences.getFolders().contains(entity.parent.path) ==
                false) {
              songs.add(await _tagger.readTagsAsMap(path: entity.path));
              _files.add(entity);
            }
          }
        }
      }
    }
    if (await Directory("/storage/emulated/0/Songs/").exists()) {
      for (FileSystemEntity entity in Directory("/storage/emulated/0/Songs/")
          .listSync(recursive: true, followLinks: false)) {
        if (entity.path.endsWith(".mp3")) {
          if (Preferences.getFolders().contains(entity.parent.path) == false) {
            songs.add(await _tagger.readTagsAsMap(path: entity.path));
            _files.add(entity);
          }
        }
      }
    }
    if (await Directory("/storage/emulated/0/snaptube/").exists()) {
      for (FileSystemEntity entity in Directory("/storage/emulated/0/snaptube/")
          .listSync(recursive: true, followLinks: false)) {
        if (entity.path.endsWith(".mp3")) {
          if (Preferences.getFolders().contains(entity.parent.path) == false) {
            songs.add(await _tagger.readTagsAsMap(path: entity.path));
            _files.add(entity);
          }
        }
      }
    }
    createAssetFile();
    for (var i = 0; i < _files.length; i++) {
      if (await _tagger.readArtwork(path: _files[i].path) != null &&
          await _tagger.readArtwork(path: _files[i].path) != [] &&
          (await _tagger.readArtwork(path: _files[i].path))!.isNotEmpty) {
        songs[i]?["artWork"] = await createFile(songs[i]?["title"],
            await _tagger.readArtwork(path: _files[i].path));
      }
      songs[i]?["audioFile"] =
          await _tagger.readAudioFileAsMap(path: _files[i].path);
      songs[i]?["path"] = _files[i].path;
      songs[i]?["parent"] = _files[i].parent.path;
      if (songs[i]?["title"] == null ||
          songs[i]?["title"] == "" ||
          (songs[i]?["title"] as String).isEmpty) {
        songs[i]?["title"] = "Undefined";
      }
      if (songs[i]?["artist"] == null ||
          songs[i]?["artist"] == "" ||
          (songs[i]?["artist"] as String).isEmpty) {
        songs[i]?["artist"] = "Unknown";
      }
      if (songs[i]?["album"] == null ||
          songs[i]?["album"] == "" ||
          (songs[i]?["album"] as String).isEmpty) {
        songs[i]?["album"] = "Unknown";
      }
      if (songs[i]?["albumArtist"] == null ||
          songs[i]?["albumArtist"] == "" ||
          (songs[i]?["albumArtist"] as String).isEmpty) {
        songs[i]?["albumArtist"] = "Unknown";
      }
      if (songs[i]?["genre"] == null ||
          songs[i]?["genre"] == "" ||
          (songs[i]?["genre"] as String).isEmpty) {
        songs[i]?["genre"] = "Unknown";
      }
      if (songs[i]?["year"] == null ||
          songs[i]?["year"] == "" ||
          (songs[i]?["year"] as String).isEmpty) {
        songs[i]?["year"] = "Unknown";
      }
      if (songs[i]?["artWork"] == null ||
          songs[i]?["artWork"] == "" ||
          (songs[i]?["artWork"] as String).isEmpty) {
        songs[i]?["artWork"] =
            "${(await getApplicationDocumentsDirectory()).path}/Cover.jpg";
      }
    }
    songs.sort((a, b) => a!["title"]
        .toString()
        .toLowerCase()
        .compareTo(b!["title"].toString().toLowerCase()));
  }

  Future<void> createAssetFile() async {
    final File file = await File(
            "${(await getApplicationDocumentsDirectory()).path}/Cover.jpg")
        .create(recursive: true);
    await file.writeAsBytes((await rootBundle.load("assets/Cover.png"))
        .buffer
        .asUint8List((await rootBundle.load("assets/Cover.png")).offsetInBytes,
            (await rootBundle.load("assets/Cover.png")).lengthInBytes));
  }

  Future<String> createFile(String title, Uint8List? byteData) async {
    final File file = await File(
            "${(await getApplicationDocumentsDirectory()).path}/$title.jpg")
        .create(recursive: true);
    await file.writeAsBytes(byteData!);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wavy Beats",
      debugShowCheckedModeBanner: false,
      home: _homePage,
      theme: lightMode(),
      darkTheme: darkMode(),
      themeMode: modeManager.mode,
    );
  }
}
