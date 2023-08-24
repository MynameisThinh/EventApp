import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCurrent extends StatefulWidget {
  const LocationCurrent({super.key});

  @override
  State<LocationCurrent> createState() => _LocationCurrentState();
}

class _LocationCurrentState extends State<LocationCurrent> {
  String result = "";
  String lat = "";
  String lng = "";

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vị trí hiện tại của người dùng"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getMapButton(),
            SizedBox(
              height: 20,
            ),
            _getLocationButton(),
            displayLocation()
          ],
        ),
      ),
    );
  }

  Widget _getLocationButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(fixedSize: Size(300, 50)),
        onPressed: () {
          getUserLocation();
        },
        child: Text(
          "Chọn vị trí",
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _getMapButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(fixedSize: Size(300, 50)),
        onPressed: () {
          gotoMap();
        },
        child: Text(
          "Đến Google Map",
          style: TextStyle(fontSize: 20),
        ));
  }

  //check if location permission is enable
  Future<bool> checkPermission() async {
    bool isEnable = false;
    LocationPermission permission;

    //check if location is enable
    isEnable = await Geolocator.isLocationServiceEnabled();
    if (!isEnable) {
      return false;
    }

    //check if use allow location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // if permission is denied then request user to allow permission again
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // if permission denied again
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  //get user current location
  getUserLocation() async {
    var isEnable = await checkPermission();
    if (isEnable) {
      Position location = await Geolocator.getCurrentPosition();
      setState(() {
        result = "";
        lat = location.latitude.toString();
        lng = location.latitude.toString();
      });
    } else {
      setState(() {
        result = "Permission is not allow";
      });
    }
  }

  Widget displayLocation() {
    return Column(
      children: [
        Text(
          result,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          lat,
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        Text(
          lng,
          style: TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  gotoMap() {
    try {
      var url =
          "https://www.google.com/maps/dir/?api=1&destination=11.6021526,104.9112173";
      final Uri _url = Uri.parse(url);
      launchUrl(_url);
    } catch (_) {
      print("Lỗi launch Map");
    }
  }
}
