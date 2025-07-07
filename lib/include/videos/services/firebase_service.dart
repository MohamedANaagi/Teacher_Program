// services/firebase_service.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<DocumentSnapshot> getUserById(String id) =>
      _firestore.collection('users').doc(id).get();
  static Future<void> updateUser(String id) =>
      _firestore.collection('users').doc(id).update({'isused': true});

  static Future<List<String>> getCourseVideos(String courseName) async {
    final ref = _storage.ref().child('courses/$courseName');
    final result = await ref.listAll();
    return await Future.wait(result.items.map((item) => item.getDownloadURL()));
  }
}
