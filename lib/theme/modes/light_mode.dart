import 'package:flutter/material.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/theme/custom.dart';

ThemeData lightMode() => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CustomTheme.white,
    fontFamily: "Samsung-Sans",
    appBarTheme: AppBarTheme(
        foregroundColor: CustomTheme.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: themeManager.primaryColor),
        titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
            color: CustomTheme.white)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomTheme.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme:
            IconThemeData(color: CustomTheme.black, opacity: 1, size: 30),
        unselectedIconTheme:
            IconThemeData(color: CustomTheme.black, opacity: 0.7)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor:
                MaterialStateProperty.all(themeManager.primaryColor),
            elevation: MaterialStateProperty.all(0),
            textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 20)))),
    sliderTheme: SliderThemeData(
        thumbColor: themeManager.primaryColor,
        activeTrackColor: themeManager.primaryColor,
        inactiveTrackColor: CustomTheme.grey,
        overlayColor: themeManager.primaryColor.withOpacity(0.5)),
    listTileTheme: ListTileThemeData(textColor: CustomTheme.black),
    dividerColor: CustomTheme.black.withOpacity(0.2),
    textTheme: TextTheme(
        headline3: TextStyle(
            color: CustomTheme.black,
            fontFamily: "Samsung-Sans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1),
        headline5: TextStyle(
            color: CustomTheme.black,
            fontFamily: "Samsung-Sans",
            fontSize: 17,
            fontWeight: FontWeight.w500)),
    iconTheme: IconThemeData(color: CustomTheme.black),
    tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
            color: CustomTheme.light.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5)),
        textStyle: TextStyle(
            color: CustomTheme.black,
            fontFamily: "Samsung-Sans",
            fontWeight: FontWeight.w600,
            letterSpacing: 1)),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: themeManager.primaryColor,
        contentTextStyle: TextStyle(
            color: CustomTheme.white,
            fontFamily: "Samsung-Sans",
            fontWeight: FontWeight.w600,
            letterSpacing: 1)));
