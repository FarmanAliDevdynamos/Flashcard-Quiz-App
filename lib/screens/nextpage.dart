import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'quizpage.dart';

class NewPage extends StatefulWidget {
  const NewPage({
    super.key,
    required this.title,
    required this.image,
    required this.cardId,
  });

  final String title;
  final String image;
  final int cardId;

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final questions =
          await DatabaseHelper().getQuestionsByCardId(widget.cardId);
      setState(() {
        _questions = List<Map<String, dynamic>>.from(questions);
      });
    } catch (e) {
      _showErrorSnackbar('Failed to load questions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _startQuiz() {
    if (_questions.length < 4) {
      _showErrorSnackbar("Please add at least 4 questions to start the quiz.");
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizPage(
          questions: _questions,
          image: widget.image,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005B96),
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
            onPressed: () => _showAddQuestionDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.quiz, color: Colors.white),
            onPressed: _startQuiz,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Column(
                children: [
                  Image.asset(widget.image, fit: BoxFit.cover),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Card(
                                elevation: 0,
                                color: const Color(0xFFF0F4F8),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                                text: 'Q: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF005B96),
                                                    fontSize: 20)),
                                            TextSpan(
                                                text: _capitalize(
                                                    _questions[index]
                                                            ['question'] ??
                                                        'N/A'),
                                                style: GoogleFonts.lobster(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xFF4B9CD3),
                                                    fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                                text: 'A: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF005B96),
                                                    fontSize: 20)),
                                            TextSpan(
                                                text: _capitalize(
                                                    _questions[index]
                                                            ['answer'] ??
                                                        'N/A'),
                                                style: GoogleFonts.lobster(
                                                    color:
                                                        const Color(0xFF8BC34A),
                                                    fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.orange),
                                            onPressed: () =>
                                                _showEditQuestionDialog(index),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _confirmDeleteQuestion(index),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _showAddQuestionDialog(BuildContext context) {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: questionController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Question')),
              TextField(
                  controller: answerController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Correct Answer')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String questionText = questionController.text.trim();
                String answerText = answerController.text.trim();

                if (questionText.isEmpty || answerText.isEmpty) {
                  _showErrorSnackbar('Both fields are required');
                  return;
                }

                await DatabaseHelper().insertQuestion({
                  'question': questionText,
                  'answer': answerText,
                  'cardId': widget.cardId,
                });
                _loadQuestions();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditQuestionDialog(int index) {
    final TextEditingController questionController =
        TextEditingController(text: _questions[index]['question'] ?? '');
    final TextEditingController answerController =
        TextEditingController(text: _questions[index]['answer'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Edit Question'),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: 'Edit Answer'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String questionText = questionController.text.trim();
                String answerText = answerController.text.trim();

                if (questionText.isEmpty || answerText.isEmpty) {
                  _showErrorSnackbar('Both fields are required');
                  return;
                }

                await DatabaseHelper().updateQuestion(
                  _questions[index]['id'], // ID
                  {
                    'question': questionText,
                    'answer': answerText,
                    'cardId': widget.cardId,
                  },
                );
                _loadQuestions();
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Question'),
          content: const Text('Are you sure you want to delete this question?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().deleteQuestion(_questions[index]['id']);
                _loadQuestions();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
