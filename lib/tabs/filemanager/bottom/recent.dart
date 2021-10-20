import 'package:flutter/material.dart';

class recentFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Recent files shown here',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/cam'),
          child: const Icon(Icons.camera_alt),
        ),
    );
  }
}