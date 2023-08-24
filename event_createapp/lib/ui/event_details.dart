import 'package:appwrite/models.dart';
import 'package:event_createapp/constants/colors.dart';
import 'package:event_createapp/database.dart';
import 'package:event_createapp/googlemap/location_current.dart';
import 'package:event_createapp/savedata.dart';
import 'package:flutter/material.dart';

import '../containers/format_datetime.dart';

class EventDetails extends StatefulWidget {
  final Document data;
  const EventDetails({super.key, required this.data});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isRSVPedEvent = false;
  String id = "";

  bool isUserPresent(List<dynamic> participants, String userId) {
    return participants.contains(userId);
  }

  @override
  void initState() {
    id = SavedData.getUserId();
    isRSVPedEvent = isUserPresent(widget.data.data["participants"], id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            Container(
              height: 300,
              width: double.infinity,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                child: Image.network(
                  "https://cloud.appwrite.io/v1/storage/buckets/64e21b7463990c6414ef/files/${widget.data.data["image"]}/view?project=64e06661b4df30f5ed19",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 25,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: Colors.white,
                  )),
            ),
            Positioned(
              bottom: 45,
              left: 8,
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${formatDate(widget.data.data["datetime"])}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  const Icon(
                    Icons.access_time_outlined,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${formatTime(widget.data.data["datetime"])}",
                    style:const  TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 8,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${widget.data.data["location"]}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.data.data["name"],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    )),
                    const Icon(Icons.share),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.data.data["description"],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "${widget.data.data["participants"].length} người tham dự.",
                  style: const TextStyle(
                    color: kLightGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Khách mời",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "${widget.data.data["guests"] == "" ? "None" : widget.data.data["guests"]}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Tài trợ ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
                Text(
                  "${widget.data.data["sponsers"] == "" ? "None" : widget.data.data["sponsers"]}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Thêm chi tiết",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Loại sự kiện : ${widget.data.data["isInPerson"] == true ? "In Person" : "Virtual"}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Thời gian : ${formatTime(widget.data.data["datetime"])}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Địa điểm : ${(widget.data.data["location"])}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LocationCurrent()));
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("Mở google map để xem vị trí")),
                const SizedBox(
                  height: 8,
                ),
                isRSVPedEvent
                    ? SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: MaterialButton(
                          color: kLightGreen,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Bạn đã tham gia vào sự kiệm")));
                          },
                          child: const Text(
                            "Tham gia sự kiện",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 20),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: MaterialButton(
                          color: kLightGreen,
                          onPressed: () {
                            rsvpEvent(widget.data.data["participants"],
                                    widget.data.$id)
                                .then((value) {
                              if (value) {
                                setState(() {
                                  isRSVPedEvent = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("RSVP thành công")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Xảy ra lỗi. Vui lòng thử lại")));
                              }
                            });
                          },
                          child: const Text(
                            "RSVP cho sự kiện",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 20),
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
