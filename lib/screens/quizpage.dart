import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String image;

  const QuizPage({super.key, required this.questions, required this.image});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int score = 0;
  int currentQuestionIndex = 0;
  late List<String?> selectedOptions; // Initialize later

  @override
  void initState() {
    super.initState();
    // Initialize the selectedOptions list with null values
    selectedOptions = List.filled(widget.questions.length, null);
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestionIndex < widget.questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: ListView(
          children: [
            QuizItem(
              questionData: {
                ...widget.questions[currentQuestionIndex],
                'selectedOption': selectedOptions[
                    currentQuestionIndex], // Pass selected option
              },
              allQuestions: widget.questions,
              onOptionSelected: (selected) {
                setState(() {
                  selectedOptions[currentQuestionIndex] = selected;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Check if the selected answer is correct
                  if (selectedOptions[currentQuestionIndex] ==
                      widget.questions[currentQuestionIndex]['answer']) {
                    score++;
                  }

                  // Move to the next question or show results
                  if (currentQuestionIndex < widget.questions.length - 1) {
                    setState(() {
                      currentQuestionIndex++;
                    });
                  } else {
                    _showResults(context);
                  }
                },
                child: const Text('Next Question'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Completed'),
        ),
        body: Center(
          child: Text(
            'Your Score: $score/${widget.questions.length}',
            style: GoogleFonts.lobster(fontSize: 24),
          ),
        ),
      );
    }
  }

  void _showResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Results'),
        content: Text('Your Score: $score/${widget.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}

class QuizItem extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final List<Map<String, dynamic>> allQuestions;
  final ValueChanged<String?> onOptionSelected;

  const QuizItem({
    super.key,
    required this.questionData,
    required this.allQuestions,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    String correctAnswer = questionData['answer'];
    List<String> options = [correctAnswer];

    // Generate random options from other questions
    while (options.length < 4) {
      String randomAnswer =
          allQuestions[_randomIndex(allQuestions.length)]['answer'];
      if (!options.contains(randomAnswer)) {
        options.add(randomAnswer);
      }
    }

    options.shuffle(); // Shuffle options

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q: ${questionData['question']}',
              style: GoogleFonts.lobster(fontSize: 20),
            ),
            const SizedBox(height: 10),
            ...options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: questionData[
                    'selectedOption'], // Use the correct group value
                onChanged: (value) {
                  onOptionSelected(
                      value); // Notify the parent widget of selection
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  int _randomIndex(int max) {
    return (DateTime.now().millisecondsSinceEpoch % max).toInt();
  }
}
