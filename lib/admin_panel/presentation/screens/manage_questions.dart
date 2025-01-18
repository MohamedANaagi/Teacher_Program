import 'package:flutter/material.dart';

import '../../domain/questions _usecase.dart';
class QuestionManagementScreen extends StatefulWidget {
  final String courseName;
  final String videoName;

  QuestionManagementScreen({
    required this.courseName,
    required this.videoName,
  });

  @override
  _QuestionManagementScreenState createState() =>
      _QuestionManagementScreenState();
}

class _QuestionManagementScreenState extends State<QuestionManagementScreen> {
  late FetchQuestionsUseCase fetchQuestionsUseCase;
  late AddQuestionUseCase addQuestionUseCase;
  late DeleteQuestionUseCase deleteQuestionUseCase;
  late EditQuestionUseCase editQuestionUseCase;

  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestionsUseCase = FetchQuestionsUseCase();
    addQuestionUseCase = AddQuestionUseCase();
    deleteQuestionUseCase = DeleteQuestionUseCase();
    editQuestionUseCase = EditQuestionUseCase();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final result =
        await fetchQuestionsUseCase.call(widget.courseName, widget.videoName);
    setState(() {
      questions = result;
    });
  }

  Future<void> showAddQuestionDialog() async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(hintText: 'Enter question'),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(hintText: 'Enter answer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (questionController.text.isNotEmpty &&
                  answerController.text.isNotEmpty) {
                await addQuestionUseCase.call(
                  widget.courseName,
                  widget.videoName,
                  questionController.text,
                  answerController.text,
                );
                loadQuestions();
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> showEditQuestionDialog(
      String currentQuestion, String currentAnswer, String questionPath) async {
    final questionController = TextEditingController(text: currentQuestion);
    final answerController = TextEditingController(text: currentAnswer);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(hintText: 'Enter question'),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(hintText: 'Enter answer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (questionController.text.isNotEmpty &&
                  answerController.text.isNotEmpty) {
                await editQuestionUseCase.call(
                  questionPath,
                  questionController.text,
                  answerController.text,
                );
                loadQuestions();
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Questions')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return ListTile(
                  title: Text(question['question']),
                  subtitle: Text('Answer: ${question['answer']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => showEditQuestionDialog(
                          question['question'],
                          question['answer'],
                          question['path'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await deleteQuestionUseCase.call(question['path']);
                          loadQuestions();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: showAddQuestionDialog,
              child: Text('Add New Question'),
            ),
          ),
        ],
      ),
    );
  }
}
