import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_scanner/modules/themechanger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicDrawer extends StatefulWidget {
  PublicDrawer({Key? key}) : super(key: key);

  @override
  _PublicDrawerState createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  bool _isDeug = false;
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _isDeug = (preferences!.getBool('isDebug') ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
     initializePreference().whenComplete(() {
       setState(() {});
     });
  }


  Widget DeveloperMode() {
    if(_isDeug) {
      return ListTile(
              title: const Text('Debug'),
              leading: Icon(Icons.bug_report),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                const newRouteName = "/debug";
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                  return true;
                });

                if (!isNewRouteSameAsCurrent) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(newRouteName);
                } else {
                  Navigator.pop(context);
                }
              },
            );
    }
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage("assets/img/No_AI_bullet_curve.png"),
                     fit: BoxFit.cover
                )
              ),
              child: 
                Text(""),
            ),
            ListTile(
              title: const Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                const newRouteName = "/cam";
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                  return true;
                });

                if (!isNewRouteSameAsCurrent) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(newRouteName);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: const Text('Scanner'),
              leading: Icon(Icons.scanner),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                const newRouteName = "/cam";
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                  return true;
                });

                if (!isNewRouteSameAsCurrent) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(newRouteName);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: const Text('File Manager'),
              leading: Icon(Icons.folder_open),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                const newRouteName = "/file";
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                  return true;
                });

                if (!isNewRouteSameAsCurrent) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(newRouteName);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: const Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                const newRouteName = "/settings";
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                  return true;
                });

                if (!isNewRouteSameAsCurrent) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(newRouteName);
                } else {
                  Navigator.pop(context);
                }
                // Navigator.pop(context);
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                // content: Text('Unavailable! Premium user only can use this menu!'),
                // duration: const Duration(seconds: 2),
                // ));
          // final snackBar = SnackBar(
          //   content: const Text('Unavailable! For premium uses only'),
          //   action: SnackBarAction(
          //     label: 'OK',
          //     onPressed: () {
          //       // Some code to undo the change.
          //     },
          //   ),
          // );

          // // Find the ScaffoldMessenger in the widget tree
          // // and use it to show a SnackBar.
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            DeveloperMode(),
          ],
        ),
    );
  }
}
