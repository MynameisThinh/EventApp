import 'package:appwrite/models.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_createapp/constants/colors.dart';
import 'package:event_createapp/containers/events_container.dart';
import 'package:event_createapp/database.dart';
import 'package:event_createapp/savedata.dart';
import 'package:event_createapp/ui/create_event_page.dart';
import 'package:event_createapp/ui/popular_item.dart';
import 'package:event_createapp/ui/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "User";

  List<Document> events = [];
  bool isLoading = true;
  @override
  void initState() {
    userName = SavedData.getUserName().split(" ")[0];
    refresh();
    super.initState();
  }

  void refresh() {
    getAllEvents().then((value) {
      events = value;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () async {
                //logoutUser();
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: Icon(
                Icons.account_circle,
                color: kLightGreen,
                size: 30,
              ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Xin chào ${userName} 👋",
                  style: TextStyle(
                      color: kLightGreen,
                      fontSize: 32,
                      fontWeight: FontWeight.w300),
                ),
                Text("Xây dựng mọi thứ xung quanh bạn",
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w300)),
                isLoading
                    ? const SizedBox()
                    : CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.99,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: [
                          ...List.generate(2, (index) {
                            return EventContainer(
                              data: events[index],
                            );
                          }),
                        ],
                      ),
                const SizedBox(height: 16),
                Text(
                  "Sự kiện nổi bật",
                  style: TextStyle(
                    color: kLightGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: const Color(0xFF2E2E2E),
                child: isLoading
                    ? const SizedBox()
                    : Column(
                        children: [
                          for (int i = 0; i < events.length && i < 5; i++) ...[
                            PopularItem(
                              eventData: events[i],
                              index: i + 1,
                            ),
                            const Divider(),
                          ],
                        ],
                      ),
              )
            ]),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 2, top: 8, left: 6, right: 6),
              child: Text(
                "Tất cả sự kiện",
                style: TextStyle(
                  color: kLightGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => EventContainer(data: events[index]),
                childCount: events.length),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateEventPage()));
          refresh();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: kLightGreen,
      ),
    );
  }
}
