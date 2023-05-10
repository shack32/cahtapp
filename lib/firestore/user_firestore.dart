import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/model/model.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFireStore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<String?> insertNewAccount() async {
    try {
      final newDoc =
          await _userCollection.add({'name': 'noneName', 'imagePath': ''});
      print('アカウント作成完了');
      return newDoc.id;
    } catch (e) {
      print('アカウント作成エラー ==== $e');
      return null;
    }
  }

  static Future<void> createUser() async {
    final myUid = await insertNewAccount();
    if (myUid != null) {
      await RoomFirestore.createRoom(myUid);
      await SharedPrefs.setUid(myUid);
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs;
    } catch (e) {
      print('ユーザー情報の取得失敗===$e');
      return null;
    }
  }

  static Future<User?> fetchProfile(String uid) async {
    try {
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(
          name: snapshot.data()!['name'],
          imagePath: snapshot.data()!['imaga_path'],
          uid: uid);
      return user;
    } catch (e) {
      print('自分のユーザー情報の取得失敗===$e');
      return null;
    }
  }

  static Future<void> updateUser(User newProfile) async {
    try {
      await _userCollection.doc(newProfile.uid).update(
          {'name': newProfile.name, 'image_path': newProfile.imagePath});
    } catch (e) {
      print('自分のユーザー情報の更新失敗===$e');
      return null;
    }
  }
}
