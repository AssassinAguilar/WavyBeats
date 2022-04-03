import 'package:flutter/material.dart';
import 'package:wavy_beats/screens/home/pages/favourites/favourites.dart';
import 'package:wavy_beats/screens/home/pages/settings.dart';
import 'package:wavy_beats/screens/home/pages/tracks.dart';
import 'package:wavy_beats/screens/home/widgets/bottom_navigation_bar.dart';

class MyHome extends StatefulWidget {
  final int index;
  const MyHome({Key? key, required this.index}) : super(key: key);

  static void reload(BuildContext context) => context.findAncestorStateOfType<_MyHomeState>()?.reload();

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late int _pageIndex;
  late List<Widget> _pages;
  late PageController _pageController;
  Key key = UniqueKey();
  @override
  void initState() {
    super.initState();
    _pages = const [
       FavouritesPage(),
       TracksPage(),
      SettingsPage()
    ];
    _pageIndex = widget.index;
    _pageController = PageController(initialPage: _pageIndex);
  }

  void reload() => setState(() => key = UniqueKey());

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: PageView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _pageController,
              children: _pages,
              clipBehavior: Clip.antiAlias,
              onPageChanged: (int index) => setState(() {
                    _pageIndex = index;
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear);
                  })),
          bottomNavigationBar: CustomBottomNavigationBar(
              key: key,
              currentIndex: _pageIndex,
              onTap: (int index) => setState(() {
                    _pageIndex = index;
                    _pageController.jumpToPage(index);
                  }))),
    );
  }
}
