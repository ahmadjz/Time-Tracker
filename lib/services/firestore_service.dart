import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService
      ._(); // this two lines is to make a singleton class se we make only on instance of it, by this we can't call this class without .instance

  final _service = FirebaseFirestore.instance;

  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T Function(QueryDocumentSnapshot<Map<String, dynamic>> data)
          builder}) {
    final reference = _service.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot),
        )
        .toList());
  }

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final documentReference = _service.doc(path);
    documentReference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }
}
