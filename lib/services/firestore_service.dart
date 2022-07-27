import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final docRef = FirebaseFirestore.instance.doc(path);
    print('path $path, data: $data');
    await docRef.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final docRef = FirebaseFirestore.instance.collection(path);
    final snapshots = docRef.snapshots();
    return snapshots.map(
        (snapshot) => snapshot.docs.map((doc) => builder(doc.data())).toList());
  }
}
