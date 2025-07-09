// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> validateCode(String code) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('id', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return false;

      final doc = query.docs.first;
      if (doc['isUsed'] == true) return false;

      await doc.reference.update({'isUsed': true});
      return true;
    } catch (e) {
      throw Exception('فشل في التحقق من الكود');
    }
  }
}
