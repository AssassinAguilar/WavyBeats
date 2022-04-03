import 'package:flutter/material.dart';
import 'package:wavy_beats/screens/home/widgets/list_tile.dart';
import 'package:wavy_beats/screens/home/widgets/top_bar.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/widgets/divider.dart';

class TracksPage extends StatefulWidget {
  const TracksPage({Key? key}) : super(key: key);

  static void reload(BuildContext context) =>
      context.findAncestorStateOfType<_TracksPageState>()?.reload();

  @override
  State<TracksPage> createState() => _TracksPageState();
}

class _TracksPageState extends State<TracksPage> {
  Key key = UniqueKey();

  void reload() => setState(() => key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        key: key,
        child: songs.isEmpty
            ? Center(
                child: Text("There are no songs to play",
                    style: Theme.of(context).textTheme.headline5))
            : Column(children: [
                TopBar(false),
                Expanded(
                    child: ListView.builder(
                        itemCount: songs.length,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (BuildContext context, int index) =>
                            Column(children: [
                              CustomTile(false, index),
                              if (index != songs.length - 1)
                                const CustomDivider()
                            ])))
              ]));
  }
}
