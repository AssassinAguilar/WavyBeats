import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wavy_beats/screens/home/home.dart';
import 'package:wavy_beats/screens/player/widgets/control_buttons.dart';
import 'package:wavy_beats/theme/custom.dart';
import 'package:wavy_beats/theme/manager/theme_manager.dart';
import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';
import 'package:wavy_beats/widgets/divider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _playSpeed;
  late bool _skipSilence;
  late int _skipInterval;
  late Duration _lastDuration;
  late List<String> _hiddenFolders;

  @override
  void initState() {
    super.initState();
    _playSpeed = Preferences.getPlaySpeed();
    _skipSilence = Preferences.getIsSilenceSkipped();
    _skipInterval = Preferences.getSkipInterval();
    _lastDuration = Duration(
        hours: Preferences.getSleepTimerH(),
        minutes: Preferences.getSleepTimerM());
    _hiddenFolders = Preferences.getFolders();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
        fontSize: 12,
        color: Theme.of(context).listTileTheme.textColor!.withOpacity(0.7));
    return Container(
        padding: const EdgeInsets.symmetric(vertical: defaultValue),
        child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              ListTile(
                  title: const Text("Sleep Timer"),
                  subtitle: Text("Stops the music after the given time",
                      style: style),
                  trailing: Text(_lastDuration.inMinutes == 0 ? "Off" : "On",
                      style: TextStyle(color: themeManager.primaryAccentColor)),
                  onTap: () {
                    showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width - 50,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: CustomTheme.spreadShadow,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(defaultValue),
                                    topLeft: Radius.circular(defaultValue))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CupertinoTheme(
                                      data: CupertinoThemeData(
                                          brightness:
                                              Theme.of(context).brightness),
                                      child: CupertinoTimerPicker(
                                          initialTimerDuration: _lastDuration,
                                          alignment: Alignment.bottomCenter,
                                          mode: CupertinoTimerPickerMode.hm,
                                          onTimerDurationChanged:
                                              (Duration duration) {
                                            Preferences.setSleepTimerH(
                                                int.parse(duration
                                                    .toString()
                                                    .split(".")[0]
                                                    .split(":")[0]));
                                            Preferences.setSleepTimerM(
                                                int.parse(duration
                                                    .toString()
                                                    .split(".")[0]
                                                    .split(":")[1]));
                                          })),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            child: const Text("Save"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() => _lastDuration =
                                                  Duration(
                                                      hours: Preferences
                                                          .getSleepTimerH(),
                                                      minutes: Preferences
                                                          .getSleepTimerM()));
                                              audioHandler?.customAction(
                                                  "sleepTimer", {
                                                "time": _lastDuration.inMinutes
                                              });
                                            }),
                                        ElevatedButton(
                                            child: const Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        ElevatedButton(
                                            child: const Text("Clear"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Preferences.setSleepTimerH(0);
                                              Preferences.setSleepTimerM(0);
                                              setState(() => _lastDuration =
                                                  Duration.zero);
                                              audioHandler?.customAction(
                                                  "sleepTimer", {
                                                "time": _lastDuration.inMinutes
                                              });
                                            })
                                      ])
                                ])));
                  }),
              const CustomDivider(),
              ListTile(
                  title: const Text("Play Speed"),
                  subtitle: Slider.adaptive(
                      min: 0.5,
                      max: 1.5,
                      divisions: 10,
                      value: _playSpeed,
                      onChanged: (val) {
                        audioHandler?.customAction("setSpeed", {"speed": val});
                        setState(() => _playSpeed = Preferences.getPlaySpeed());
                      }),
                  trailing: Text(_playSpeed.toString(),
                      style:
                          TextStyle(color: themeManager.primaryAccentColor))),
              const CustomDivider(),
              ListTile(
                  title: const Text("Skip Silence"),
                  subtitle: Text(
                      "Automatically Skips The Silence Between The Track",
                      style: style),
                  trailing: Switch.adaptive(
                      activeColor: themeManager.primaryColor,
                      activeTrackColor: themeManager.primaryAccentColor,
                      inactiveTrackColor: CustomTheme.grey,
                      value: _skipSilence,
                      onChanged: (val) {
                        audioHandler?.customAction(
                            "skipSilence", {"IsSilenceSkipped": val});
                        setState(() =>
                            _skipSilence = Preferences.getIsSilenceSkipped());
                      })),
              const CustomDivider(),
              ListTile(
                  title: const Text("Skip Interval"),
                  subtitle: Text("Sets the skip interval for th player",
                      style: style),
                  trailing: Text(_skipInterval.toString() + "s",
                      style: TextStyle(color: themeManager.primaryAccentColor)),
                  onTap: () async {
                    final List intervals = [5, 10, 30];
                    showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: CustomTheme.spreadShadow,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(defaultValue),
                                    topLeft: Radius.circular(defaultValue))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                    intervals.length,
                                    (index) => ElevatedButton(
                                        child: Text(
                                            intervals[index].toString() + "s"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Preferences.setSkipInterval(
                                              intervals[index]);
                                          setState(() => _skipInterval =
                                              Preferences.getSkipInterval());
                                          ControlButtons.reload(context);
                                        })))));
                  }),
              const CustomDivider(),
              ListTile(
                  title: const Text("Hide Folders"),
                  subtitle: Text("Hides The Folders From The Library Screen",
                      style: style),
                  trailing: Text("Choose Folder",
                      style: TextStyle(color: themeManager.primaryAccentColor)),
                  onTap: () async {
                    _hiddenFolders.add(
                        (await FilePicker.platform.getDirectoryPath())
                            .toString());
                    _hiddenFolders.toSet().toList();
                    Preferences.setFolders(_hiddenFolders);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Re-run the app to reflect the changes")));
                  }),
              const CustomDivider(),
              ListTile(
                  title: const Text("Unhide Folders"),
                  subtitle: Text("Unhide The Folders From The Library Screen",
                      style: style),
                  trailing: Text("Choose Folder",
                      style: TextStyle(color: themeManager.primaryAccentColor)),
                  onTap: () async {
                    if (Preferences.getFolders().contains(
                        (await FilePicker.platform.getDirectoryPath())
                            .toString())) {
                      _hiddenFolders.remove(
                          (await FilePicker.platform.getDirectoryPath())
                              .toString());
                    }
                    _hiddenFolders.toSet().toList();
                    Preferences.setFolders(_hiddenFolders);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Re-run the app to reflect the changes")));
                  }),
              const CustomDivider(),
              ListTile(
                  title: const Text("Switch Mode"),
                  subtitle: Text("Choose A Mode To Change With The Current One",
                      style: style),
                  trailing: Text(modeManager.modeName,
                      style: TextStyle(color: themeManager.primaryAccentColor)),
                  onTap: () => showCupertinoModalPopup<void>(
                      context: context,
                      builder: (builder) => CupertinoActionSheet(
                          actions: List.generate(
                              modeNames.length,
                              (index) => CupertinoActionSheetAction(
                                  child: Text(modeNames[index],
                                      style: TextStyle(
                                          color:
                                              themeManager.primaryAccentColor)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    modeManager.changeMode(index);
                                  }))))),
              const CustomDivider(),
              ListTile(
                  title: const Text("Switch Theme"),
                  subtitle: Text(
                      "Choose A Theme To Change With The Current One",
                      style: style),
                  trailing: Text(themeManager.themeName,
                      style: TextStyle(color: themeManager.primaryAccentColor)),
                  onTap: () => showCupertinoModalPopup<void>(
                      context: context,
                      builder: (builder) => CupertinoActionSheet(
                          actions: List.generate(
                              themeCode.length,
                              (index) => CupertinoActionSheetAction(
                                  child: Text(themeCode[index][2],
                                      style: TextStyle(
                                          color: themeCode[index][0])),
                                  onPressed: () {
                                    MyHome.reload(context);
                                    Navigator.of(context).pop();
                                    themeManager.changeTheme(index);
                                  }))))),
              const CustomDivider(),
              ListTile(
                title: const Text("About Wavy Beats"),
                trailing: Icon(Icons.info_outline,
                    color: themeManager.primaryAccentColor),
                onTap: () => launch("https://github.com/AssassinAguilar/WavyBeats/"),
              )
            ]));
  }
}
