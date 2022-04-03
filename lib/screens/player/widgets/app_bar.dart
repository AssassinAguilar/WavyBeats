import 'package:flutter/material.dart';
import 'package:wavy_beats/screens/home/home.dart';
import 'package:wavy_beats/screens/details/song_details.dart';
import 'package:wavy_beats/screens/home/pages/favourites/favourites.dart';
import 'package:wavy_beats/screens/home/pages/tracks.dart';
import 'package:wavy_beats/theme/custom.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/widgets/image.dart';

class PlayerPageAppBar extends StatefulWidget {
  final String title;
  final dynamic image;
  final String lyrics;
  final bool isFavourite;
  final int pageIndex;
  const PlayerPageAppBar(
      {Key? key,
      this.title = "Unknown",
      required this.image,
      this.lyrics = "",
      this.isFavourite = false,
      this.pageIndex = 1})
      : super(key: key);

  @override
  State<PlayerPageAppBar> createState() => _PlayerPageAppBarState();
}

class _PlayerPageAppBarState extends State<PlayerPageAppBar> {
  bool _isShowingLyrics = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title.length > 25
          ? Text(
              "Now Playing from\n${widget.title.replaceRange(25, widget.title.length, "...")}",
              maxLines: 2,
              textAlign: TextAlign.center)
          : Text("Now Playing from\n${widget.title}",
              maxLines: 2, textAlign: TextAlign.center),
      leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          tooltip: "Go Back",
          onPressed: () {
            widget.isFavourite
                ? FavouritesPage.reload(context)
                : TracksPage.reload(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => WillPopScope(
                    child: MyHome(index: widget.pageIndex),
                    onWillPop: () async => false)));
          }),
      iconTheme: IconThemeData(color: CustomTheme.white),
      flexibleSpace: GestureDetector(
        child: AnimatedContainer(
            height: _isShowingLyrics
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height / 2.15,
            width: MediaQuery.of(context).size.width,
            clipBehavior: Clip.antiAlias,
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
                boxShadow: CustomTheme.boxShadow,
                borderRadius: _isShowingLyrics
                    ? BorderRadius.circular(0)
                    : BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width / 5, 50)),
                color: themeManager.primaryColor),
            child: Tooltip(
                message: widget.lyrics != "" && widget.lyrics.isNotEmpty
                    ? _isShowingLyrics
                        ? ""
                        : "Hold to show lyrics"
                    : "",
                child: widget.lyrics != "" && widget.lyrics.isNotEmpty
                    ? _isShowingLyrics
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: defaultValue * 9,
                                bottom: defaultValue * 2),
                            child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Text("L Y R I C S\n\n${widget.lyrics}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: CustomTheme.white,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w600))))
                        : CustomImage(widget.image)
                    : CustomImage(widget.image))),
        onTap: () => setState(() {
          if (widget.lyrics != "" && widget.lyrics.isNotEmpty) {
            _isShowingLyrics = !_isShowingLyrics;
          }
        }),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: "Show Info",
            splashRadius: 25,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SongDetails(
                      song: songs.firstWhere(
                          (element) => element?["album"] == widget.title),
                      isFavourite: widget.isFavourite)));
            })
      ],
    );
  }
}
