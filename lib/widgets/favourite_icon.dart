import 'package:flutter/material.dart';
import 'package:wavy_beats/screens/home/pages/favourites/favourites_model.dart';
import 'package:wavy_beats/utilities/prefs.dart';

class FavouriteIcon extends StatefulWidget {
  final String songPath;
  final double size;
  const FavouriteIcon({
    Key? key,
    required this.songPath,
    this.size = 24.0,
  }) : super(key: key);

  static void reload(BuildContext context) =>
      context.findAncestorStateOfType<_FavouriteIconState>()?.reload();

  @override
  _FavouriteIconState createState() => _FavouriteIconState();
}

class _FavouriteIconState extends State<FavouriteIcon>
    with SingleTickerProviderStateMixin {
  late bool _isFavourite;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Key key = UniqueKey();

  void reload() => setState(() => key = UniqueKey());

  @override
  void initState() {
    super.initState();
    _isFavourite = favouriteTracks.songsPath.contains(widget.songPath);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) _animationController.reverse();
      });
    _animation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: IconButton(
          key: key,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          tooltip: favouriteTracks.songsPath.contains(widget.songPath)
              ? "Remove from favourites"
              : "Add to favourites",
          onPressed: () {
            setState(() => _isFavourite = !_isFavourite);
            if (_isFavourite) {
              _animationController.forward();
              favouriteTracks.addSong(widget.songPath);
              Preferences.setFavourites(favouriteTracks.songsPath);
            } else {
              favouriteTracks.removeSong(widget.songPath);
              Preferences.setFavourites(favouriteTracks.songsPath);
            }
          },
          iconSize: widget.size,
          icon: favouriteTracks.songsPath.contains(widget.songPath)
              ? Icon(Icons.favorite_rounded,
                  color: Theme.of(context).iconTheme.color)
              : Icon(Icons.favorite_border_rounded,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.7))),
    );
  }
}
