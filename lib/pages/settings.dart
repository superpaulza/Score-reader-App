import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_scanner/modules/themechanger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class settingsPage extends StatefulWidget {
  settingsPage({Key? key}) : super(key: key);

  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  bool _isCrop = false;
  bool _isDebug = false;
  bool _isGayray = false;
  bool _themeDark = true;
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
     initializePreference().whenComplete((){
       setState(() {});
     });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _isCrop = (preferences!.getBool('isCrop') ?? false);
      _isDebug = (preferences!.getBool('isDebug') ?? false);
      _isGayray = (preferences!.getBool('isGayray') ?? false);
      _themeDark = (preferences!.getBool('isthemeDark') ?? true);
    });
  }

  // void _isCropOption(bool value) async {
  //   this.preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isCrop = (preferences!.getBool('isCrop') ?? false);
  //     preferences!.setBool('isCrop', value);
  //   });
  // }

  // void _isDebugOption(bool value) async {
  //   this.preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isCrop = (preferences!.getBool('isCrop') ?? false);
  //     preferences!.setBool('isCrop', value);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
          appBar: AppBar(
            title: Text('App Setting'),
            // leading: new IconButton(
            //   icon: new Icon(Icons.arrow_back),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ),
          body: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Manual Crop (BETA)'),
                value: _isCrop,
                onChanged: (bool value) {
                  setState(() {
                    _isCrop = value;
                    this.preferences?.setBool("isCrop", _isCrop);
                  });
                },
                secondary: const Icon(Icons.crop),
              ),
              SwitchListTile(
                title: const Text('Enable Developer Mode'),
                value: _isDebug,
                onChanged: (bool value) {
                  setState(() {
                    _isDebug = value;
                    this.preferences?.setBool("isDebug", _isDebug);
                  });
                },
                secondary: const Icon(Icons.bug_report),
              ),
              SwitchListTile(
                title: const Text('Enable เ ก เ ร Mode'),
                value: _isGayray,
                onChanged: (bool value) async {
                  setState(() {
                    _isGayray = value;
                    this.preferences?.setBool("isGayray", _isGayray);
                  });
                },
                secondary: const Icon(Icons.sports_handball_sharp),
              ),
            SwitchListTile(
              title: const Text('Theme Dark'),
              value: _themeDark,
              onChanged: (bool value) {
                setState(() {
                  ThemeChanger themeChange =
                      Provider.of<ThemeChanger>(context, listen: false);
                  _themeDark = value;
                  _themeDark
                      ? themeChange.setTheme(ThemeData.dark())
                      : themeChange.setTheme(ThemeData.light());
                  this.preferences?.setBool("isthemeDark", _themeDark);
                });
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            ]
          )
      );
  }
}