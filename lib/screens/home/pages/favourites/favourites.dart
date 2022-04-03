import 'package:flutter/material.dart';
import 'package:wavy_beats/screens/home/pages/favourites/favourites_model.dart';
import 'package:wavy_beats/screens/home/widgets/list_tile.dart';
import 'package:wavy_beats/screens/home/widgets/top_bar.dart';
import 'package:wavy_beats/widgets/divider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  static void reload(BuildContext context) =>
      context.findAncestorStateOfType<_FavouritesPageState>()?.reload();

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Key key = UniqueKey();

  void reload() => setState(() => key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        key: key,
        child: favouriteTracks.favouriteSongs.isEmpty
            ? Center(
                child: Text("No song marked as favourite",
                    style: Theme.of(context).textTheme.headline5))
            : Column(children: [
                TopBar(true),
                Expanded(
                    child: ListView.builder(
                        itemCount: favouriteTracks.favouriteSongs.length,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (BuildContext context, int index) =>
                            Column(children: [
                              CustomTile(true, index),
                              if (index !=
                                  favouriteTracks.favouriteSongs.length - 1)
                                const CustomDivider()
                            ])))
              ]));
  }
}
