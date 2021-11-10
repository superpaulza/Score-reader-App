import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingsPage extends StatefulWidget {
  settingsPage({Key? key}) : super(key: key);

  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  bool _isCrop = false;
  bool _isDebug = false;
  bool _isGayray = false;
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
          ),
          body: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Manual Crop'),
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
                title: const Text('Enable Gayray Mode'),
                value: _isGayray,
                onChanged: (bool value) {
                  setState(() {
                    _isGayray = value;
                    this.preferences?.setBool("isDebug", _isGayray);
                  });
                },
                secondary: const Icon(Icons.bug_report),
              ),
            ]
          )
      );
  }
}