
import 'package:appwrite/models.dart';
import 'package:event_createapp/constants/colors.dart';
import 'package:event_createapp/database.dart';
import 'package:event_createapp/savedata.dart';
import 'package:event_createapp/ui/event_details.dart';
import 'package:flutter/material.dart';

class RSVPEvent extends StatefulWidget {
  const RSVPEvent({super.key});

  @override
  State<RSVPEvent> createState() => _RSVPEventState();
}

class _RSVPEventState extends State<RSVPEvent> {
  List<Document> events = [];
  List<Document> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() {
    String userId = SavedData.getUserId();
    getAllEvents().then((value) {
      events = value;

      for (var event in events) {
        List<dynamic> participants = event.data["participants"];
        if (participants.contains(userId)) {
          userEvents.add(event);
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sự kiện RSVP"),
      ),
      body: ListView.builder(
          itemCount: userEvents.length,
          itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EventDetails(data: userEvents[index]))),
                  title: Text(
                    userEvents[index].data["name"],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                      "${userEvents[index].data["participants"].length} người tham dự",
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(
                    Icons.check_circle,
                    color: kLightGreen,
                  ),
                ),
              )),
    );
  }
}
