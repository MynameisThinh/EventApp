import 'package:event_createapp/constants/colors.dart';
import 'package:event_createapp/googlemap/location_current.dart';
import 'package:event_createapp/savedata.dart';
import 'package:event_createapp/ui/login.dart';
import 'package:event_createapp/ui/manage_events.dart';
import 'package:event_createapp/ui/rsvp_event.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    name = SavedData.getUserName();
    email = SavedData.getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Icon(
                    Icons.person_outlined,
                    size: 120,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RSVPEvent())),
                      leading: Icon(Icons.event_available_outlined),
                      title: Text(
                        "Sự kiện RSVP",
                        style: TextStyle(color: kLightGreen),
                      ),
                    ),
                    ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageEvents())),
                      leading: Icon(Icons.manage_accounts),
                      title: Text(
                        "Quản lý sự kiện",
                        style: TextStyle(color: kLightGreen),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationCurrent()));
                      },
                      leading: Icon(Icons.map_outlined),
                      title: Text(
                        "Truy cập vào google map",
                        style: TextStyle(color: kLightGreen),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        logoutUser();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      leading: Icon(Icons.logout_rounded),
                      title: Text(
                        "Đăng xuất",
                        style: TextStyle(color: kLightGreen),
                      ),
                    ),
                    SizedBox(
                      height: 135,
                    ),
                    Text("Version 1.0.0")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
