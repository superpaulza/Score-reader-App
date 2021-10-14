import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String route = "home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Scanner Mobile Application'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Take a picture'),
          onPressed: () {
            Navigator.pushNamed(context, '/cam');
          },
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Take a picture'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, '/cam');
              },
            ),
            ListTile(
              title: const Text('Second'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, '/2');
              },
            ),
            ListTile(
              title: const Text('File Manager'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushNamed(context, '/file');
              },
            ),
          ],
        ),
      ),
    );
  }
}