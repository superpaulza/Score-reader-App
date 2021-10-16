import 'package:flutter/material.dart';

class PublicDrawer extends StatefulWidget {
  PublicDrawer({Key? key}) : super(key: key);

  @override
  _PublicDrawerState createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Score Scanner Mobile Application'),
            ),
            ListTile(
              title: const Text('Scanner'),
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
                  Navigator.pushNamed(context, newRouteName);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: const Text('File Manager'),
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
                  Navigator.pushNamed(context, newRouteName);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
    );
  }
}