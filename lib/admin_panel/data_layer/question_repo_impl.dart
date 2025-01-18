import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchQuestions(String courseName, String videoName) async {
    final questionsSnapshot = await firestore
        .collection('courses')
        .doc(courseName)
        .collection('videos')
        .doc(videoName)
        .collection('questions')
        .get();

    return questionsSnapshot.docs
        .map((doc) => {'question': doc['question'], 'answer': doc['answer'], 'path': doc.reference.path})
        .toList();
  }

  Future<void> addQuestion(String courseName, String videoName, String question, String answer) async {
    await firestore
        .collection('courses')
        .doc(courseName)
        .collection('videos')
        .doc(videoName)
        .collection('questions')
        .add({'question': question, 'answer': answer});
  }

  Future<void> deleteQuestion(String questionPath) async {
    await firestore.doc(questionPath).delete();
  }

  Future<void> editQuestion(String questionPath, String newQuestion, String newAnswer) async {
    await firestore.doc(questionPath).update({'question': newQuestion, 'answer': newAnswer});
  }
}
