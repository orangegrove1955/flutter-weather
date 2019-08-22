import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../utils/util.dart' as util;

class FW extends StatefulWidget {
  @override
  _FWState createState() => _FWState();
}

class _FWState extends State<FW> {
  void showWeather() async {
    final coords = util.defaultCoords;
    Map data = await getWeather(coords["lat"], coords["long"]);
    final current = data['currently']['temperature'];
    print(current.toString());
  }

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
              onPressed: () => showWeather(),
              color: Colors.white,
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                'images/snow.jpg',
                fit: BoxFit.fill,
                height: 2000,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.fromLTRB(0.0, 16.0, 20.0, 0.0),
              child: Text("Spokane", style: nameStyle()),
            ),
            Container(
              alignment: Alignment.center,
            ),
            Container(
                margin: EdgeInsets.fromLTRB(32.0, 600.0, 0.0, 24.0),
                child: Text("Weather", style: weatherStyle())),
          ],
        ));
  }

  Future<Map> getWeather(double lat, double long) async {
    String apiURL =
        "https://api.darksky.net/forecast/${util.apiKey}/${lat},${long}?units=si";
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }
}

TextStyle nameStyle() {
  return TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic);
}

TextStyle weatherStyle() {
  return TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold);
}
