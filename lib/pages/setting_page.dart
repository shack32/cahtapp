import 'dart:io';

import 'package:chat_app/firestore/user_firestore.dart';
import 'package:chat_app/model/model.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  File? image;
  String imagePath = '';
  final ImagePicker _picker = ImagePicker();
  final TextEditingController controller = TextEditingController();

  Future<void> selectImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      image = File(pickedImage.path);
    });
  }

  Future<void> uploadImage() async {
    String path = image!.path.substring(image!.path.lastIndexOf('/') + 1);
    final ref = FirebaseStorage.instance.ref(path);
    final storedImage = await ref.putFile(image!);
    imagePath = await storedImage.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 150, child: Text('名前')),
                Expanded(
                    child: TextField(
                  controller: controller,
                ))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const SizedBox(width: 150, child: Text('アイコン画像')),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () async {
                              await selectImage();
                              await uploadImage();
                            },
                            child: const Text('画像を選択'))))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            image == null
                ? const SizedBox()
                : SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.file(image!, fit: BoxFit.cover)),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                    onPressed: () async {
                      User newProfile = User(
                          name: controller.text,
                          imagePath: imagePath,
                          uid: SharedPrefs.fetchUid()!);
                      await UserFireStore.updateUser(newProfile);
                    },
                    child: const Text('保存')))
          ],
        ),
      ),
    );
  }
}
