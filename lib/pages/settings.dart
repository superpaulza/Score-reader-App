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

  @override
  void initState() {
    super.initState();
  }

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
                  });
                },
                secondary: const Icon(Icons.bug_report),
              ),
            ]
          )
      );
  }
}