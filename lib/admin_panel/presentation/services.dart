import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final ListResult result = await _storage.ref().listAll();
    return result.prefixes
        .map((prefix) => {
              'name': prefix.name,
              'path': prefix.fullPath,
            })
        .toList();
  }
}
