import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../utils/util.dart' as util;

class FW extends StatefulWidget {
  @override
  _FWState createState() => _FWState();
}

class _FWState extends State<FW> {
  double getLat() {
    return util.defaultLat;
  }

  double getLong() {
    return util.defaultLong;
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
              icon: Icon(Icons.location_on),
              onPressed: () => getAll(),
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
                height: 1000,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.fromLTRB(0.0, 16.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("City", style: nameStyle()),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  updateTempWidget(getLat(), getLong()),
                ],
              ),
            ),
          ],
        ));
  }

  Future<Map> getWeather(double lat, double long) async {
    String apiURL =
        "https://api.darksky.net/forecast/${util.apiKey}/$lat,$long?units=si";
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

  Future<Position> getLocation() async {
    Geolocator geolocator = Geolocator();
    Position userLocation;
    userLocation = await geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best);
    return userLocation;
  }

  Future<Map> getAll() async {
    // Get user position and set to lat, long values
    Position user = await getLocation();
    double lat = user.latitude;
    double long = user.longitude;

    // Get the name of the location
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(lat, long);

    // Get the weather, and add the name of the location
    Map weather = await getWeather(lat, long);
    weather['name'] = placemark[0].name.toString();
    debugPrint(weather['name']);
    return weather;
  }

  Widget updateTempWidget(double lat, double long) {
    return FutureBuilder(
      future: getWeather(lat, long),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Text(
              "${content['currently']['temperature'].toString()}\u00b0C",
              style: weatherStyle());
        }
        return Container(width: 0.0, height: 0.0,);
      },
    );
  }
}

TextStyle nameStyle() {
  return TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic);
}

TextStyle weatherStyle() {
  return TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold);
}
