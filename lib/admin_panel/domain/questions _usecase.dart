import '../data_layer/question_repo_impl.dart';

class FetchQuestionsUseCase {
  final QuestionsRepository repository = QuestionsRepository();

  Future<List<Map<String, dynamic>>> call(String courseName, String videoName) {
    return repository.fetchQuestions(courseName, videoName);
  }
}

class AddQuestionUseCase {
  final QuestionsRepository repository = QuestionsRepository();

  Future<void> call(String courseName, String videoName, String question, String answer) {
    return repository.addQuestion(courseName, videoName, question, answer);
  }
}

class DeleteQuestionUseCase {
  final QuestionsRepository repository = QuestionsRepository();

  Future<void> call(String questionPath) {
    return repository.deleteQuestion(questionPath);
  }
}

class EditQuestionUseCase {
  final QuestionsRepository repository = QuestionsRepository();

  Future<void> call(String questionPath, String newQuestion, String newAnswer) {
    return repository.editQuestion(questionPath, newQuestion, newAnswer);
  }
}
