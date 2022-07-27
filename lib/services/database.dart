import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.userId});

  final String userId;

  @override
  Future<void> createJob(Job job) => FirestoreService.instance.setData(
        path: Api.jobPath(userId, 'job_abc'),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobsStream() => FirestoreService.instance.collectionStream(
        path: Api.jobs(userId),
        builder: (data) => Job.fromMap(data),
      );
}
