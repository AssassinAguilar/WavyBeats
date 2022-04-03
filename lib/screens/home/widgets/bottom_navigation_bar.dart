import 'package:flutter/material.dart';
import 'package:wavy_beats/theme/custom.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/utilities/helpers.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;
  const CustomBottomNavigationBar(
      {Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<Alignment> align = [
  Alignment.centerLeft,
  Alignment.center,
  Alignment.centerRight
];
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomTheme.white,
            boxShadow: CustomTheme.boxShadow,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultValue + 10),
                topRight: Radius.circular(defaultValue + 10))),
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          BottomNavigationBar(
              currentIndex: widget.currentIndex,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_rounded), label: "", tooltip: "Favourites"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_music_rounded), label: "", tooltip: "Library"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings_rounded), label: "", tooltip: "Settings")
              ],
              onTap: (int index) => widget.onTap!(index)),
          Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: AnimatedAlign(
                  alignment: align[widget.currentIndex],
                  curve: Curves.linear,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                      height: 3.5,
                      width: MediaQuery.of(context).size.width / 3.8,
                      decoration: BoxDecoration(
                          color: themeManager.primaryColor,
                          borderRadius:
                              BorderRadius.circular(defaultValue / 2)))))
        ]));
  }
}
