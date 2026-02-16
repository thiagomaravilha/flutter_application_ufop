import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ActivityModel>> getActivities() {
    return _db.collection('activities').orderBy('startTime').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => ActivityModel.fromMap(doc.data()..['id'] = doc.id)).toList(),
    );
  }

  Future<void> addActivity(ActivityModel activity) async {
    await _db.collection('activities').add(activity.toMap());
  }

  Future<void> updateActivity(String id, ActivityModel activity) async {
    await _db.collection('activities').doc(id).update(activity.toMap());
  }

  Future<void> deleteActivity(String id) async {
    await _db.collection('activities').doc(id).delete();
  }
}