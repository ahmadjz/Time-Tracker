import 'package:time_tracker/app/home/models/entry.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job? job});
  Stream<Job> jobStream({required String? jobID});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async =>
      _service.setData(path: APIPath.job(uid, job.id), data: job.toMap());

  // previous version
  // @override
  // Stream<List<Job>> jobsStream() => _service.collectionStream(
  //       path: APIPath.jobs(uid),
  //       builder: (data) => Job.fromMap(data.data(), data.id),
  //     );

  @override
  Stream<List<Job>> jobsStream() {
    return _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentID) => Job.fromMap(data, documentID));
  }

  @override
  Stream<Job> jobStream({required String? jobID}) => _service.documentStream(
        path: APIPath.job(uid, jobID),
        builder: (data, documentID) => Job.fromMap(data!, documentID),
      );

  @override
  Future<void> deleteJob(Job job) async =>
      _service.deleteData(path: APIPath.job(uid, job.id));

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));
}