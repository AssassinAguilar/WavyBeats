import 'package:flutter/material.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/widgets/divider.dart';

class ListDetails extends StatelessWidget {
  final Map? song;
  const ListDetails(this.song, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          ListTile(
              title: const Text("Album", maxLines: 1),
              trailing: Text(
                  (song?["album"] as String).length > 25
                      ? (song?["album"] as String)
                          .replaceRange(25, (song?["album"] as String).length, "...")
                      : song?["album"],
                  style: TextStyle(color: themeManager.primaryColor))),
          const CustomDivider(),
          ListTile(
              title: const Text("Album Artist", maxLines: 1),
              trailing: Text((song?["albumArtist"] as String).length > 25
                      ? (song?["albumArtist"] as String)
                          .replaceRange(25, (song?["albumArtist"] as String).length, "...")
                      : song?["albumArtist"],
                  style: TextStyle(color: themeManager.primaryColor))),
          const CustomDivider(),
          ListTile(
              title: const Text("Genre", maxLines: 1),
              trailing: Text(song?["genre"],
                  style: TextStyle(color: themeManager.primaryColor))),
          const CustomDivider(),
          ListTile(
              title: const Text("Release Year"),
              trailing: Text(song?["year"],
                  style: TextStyle(color: themeManager.primaryColor))),
          const CustomDivider(),
          ListTile(
              title: const Text("Format"),
              trailing: Text(song?["audioFile"]["format"],
                  style: TextStyle(color: themeManager.primaryColor))),
          const CustomDivider(),
          ListTile(
              title: const Text("Bit Rate"),
              trailing: Text(
                  (song?["audioFile"]["bitRate"]).toString() + " bit",
                  style: TextStyle(color: themeManager.primaryColor))),
          const CustomDivider(),
          ListTile(
              title: const Text("Sample Rate"),
              trailing: Text(
                  song?["audioFile"]["sampleRate"] > 1000
                      ? (song?["audioFile"]["sampleRate"] / 1000)
                              .toString()
                              .split(".")[0] +
                          " kHz"
                      : (song?["audioFile"]["sampleRate"]).toString() + " Hz",
                  style: TextStyle(color: themeManager.primaryColor))),
          const CustomDivider(),
          ListTile(
              title: const Text("Path", maxLines: 1),
              trailing: Text((song?["parent"] as String).length > 25
                      ? (song?["parent"] as String)
                          .replaceRange(25, (song?["parent"] as String).length, "...")
                      : song?["parent"],
                  style: TextStyle(color: themeManager.primaryColor)))
        ]);
  }
}
