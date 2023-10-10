import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDatabase {
  static final FirebaseFirestore database = FirebaseFirestore.instance;

// Collections
  static final CollectionReference chats = database.collection('chats');

  static void addData(
      CollectionReference collection, Map<String, dynamic> data, int chatId) {
    collection.doc('$chatId').collection('messages').add(data);
  }

  static List<QueryDocumentSnapshot<Object?>> readData(
      CollectionReference collection) {
    List<QueryDocumentSnapshot<Object?>> list = [];
    collection.get().then((value) {
      list = value.docs;
    });
    return list;
  }

  static Stream<QuerySnapshot> streamData(
      CollectionReference collection, int chatId) {
    String collectionName = collection.path;
    return database
        .collection(collectionName)
        .doc('$chatId')
        .collection('messages')
        .orderBy("time", descending: true)
        .snapshots();
  }

  static Future<int> makeNewDoc(
      CollectionReference<Object?> collection, int chatId) async {
    collection.doc('$chatId');
    return 1;
  }

  static Future<bool> checkExists(
      CollectionReference collection, int chatId) async {
    DocumentSnapshot<Object?> doc = await collection.doc('$chatId').get();
    if (doc.exists) {
      return true;
    } else {
      await makeNewDoc(collection, chatId);
      return false;
    }
  }
}
