import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/firestore/user_firestore.dart';
import 'package:chat_app/pages/top_page.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs.setPrefsInstance();
  String? uid = SharedPrefs.fetchUid();
  if (uid == null) await UserFireStore.createUser();
  print('--------uid-------');
  print(uid);
  // RoomFirestore.fetchJoinedRooms();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopPage(),
    );
  }
}
