import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService
      ._(); // this two lines is to make a singleton class se we make only on instance of it, by this we can't call this class without .instance

  final _service = FirebaseFirestore.instance;

  // simple version
  // Stream<List<T>> collectionStream<T>(
  //     {required String path,
  //     required T Function(QueryDocumentSnapshot<Map<String, dynamic>> data)
  //         builder}) {
  //   final reference = _service.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map((snapshot) => snapshot.docs
  //       .map(
  //         (snapshot) => builder(snapshot),
  //       )
  //       .toList());
  // }

  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentID) builder,
      Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
          queryBuilder,
      int Function(T lhs, T rhs)? sort}) {
    Query<Map<String, dynamic>>? query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();

    return snapshots.map(
      (snapshot) {
        final result = snapshot.docs
            .map((snapshot) {
              final snapid = snapshot.id;
              final snapdata = snapshot.data();
              return builder(
                snapdata,
                snapid,
              );
            })
            .where((value) => value != null)
            .toList();
        if (sort != null) {
          result.sort(sort);
        }
        return result;
      },
    );
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(
          snapshot.data(),
          snapshot.id,
        ));
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
