import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<DocumentSnapshot> getUserById(String id) =>
      _firestore.collection('users').doc(id).get();

  static Future<List<String>> getCourses() async {
    final ref = _storage.ref().child('courses');
    final result = await ref.listAll();
    return result.prefixes.map((prefix) => prefix.name).toList();
  }

  static Future<List<Map<String, String>>> getCourseVideos(String courseName) async {
    final ref = _storage.ref().child('courses/$courseName');
    final result = await ref.listAll();
    return await Future.wait(result.items.map((item) async {
      final url = await item.getDownloadURL();
      return {'url': url, 'name': item.name};
    }).toList());
  }

  static Future<String?> getTestLink(String courseName, String videoName) async {
    try {
      final querySnapshot = await _firestore
          .collection('tests_links')
          .where('courseName', isEqualTo: courseName)
          .where('videoName', isEqualTo: videoName)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['testLink'] as String?;
      }
      return null;
    } catch (e) {
      throw Exception('فشل في جلب رابط الاختبار: $e');
    }
  }
}