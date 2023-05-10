import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/pages/setting_page.dart';
import 'package:chat_app/pages/talk_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  // List<User> userList = [
  //   User(
  //     name: 'シャック',
  //     uid: 'shack',
  //     imagePath:
  //         'https://retro-mo.com/wp-content/uploads/2018/12/%E3%82%B7%E3%83%A3%E3%82%AD%E3%83%BC%E3%83%AB%E3%83%BB%E3%82%AA%E3%83%8B%E3%83%BC%E3%83%AB-1024x683.jpg',
  //   ),
  //   User(
  //     name: 'コービー',
  //     uid: 'kobe',
  //     imagePath:
  //         'https://basketballking.jp/wp-content/uploads/2021/01/GettyImages-1202206198-500x375.jpg',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Center(child: Text('chat app')),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: RoomFirestore.joinedRoomSnapshot,
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasData) {
                return FutureBuilder<List<TalkRoom>?>(
                    future:
                        RoomFirestore.fetchJoinedRooms(streamSnapshot.data!),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (futureSnapshot.hasData) {
                          List<TalkRoom> talkRooms = futureSnapshot.data!;
                          return ListView.builder(
                              itemCount: talkRooms.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TalkRoomPage(
                                                talkRooms[index])));
                                  },
                                  child: SizedBox(
                                    height: 70,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: talkRooms[index]
                                                        .talkUser
                                                        .imagePath ==
                                                    null
                                                ? null
                                                : NetworkImage(talkRooms[index]
                                                    .talkUser
                                                    .imagePath!),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              talkRooms[index].talkUser.name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              talkRooms[index].lastMessage ??
                                                  '',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return const Center(child: Text('トークルームの取得に失敗しました'));
                        }
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
