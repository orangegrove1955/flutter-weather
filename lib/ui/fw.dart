import 'package:flutter/material.dart';

class FW extends StatefulWidget {
  @override
  _FWState createState() => _FWState();
}

class _FWState extends State<FW> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => debugPrint("Hey"),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
