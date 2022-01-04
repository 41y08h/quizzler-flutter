import "package:flutter/material.dart";
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final quizBrain = QuizBrain();

void main() {
  runApp(MyApp());
}

class AnswerButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  const AnswerButton(this.text, this.color, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }
}

class Quizzler extends StatefulWidget {
  const Quizzler({Key key}) : super(key: key);

  @override
  State<Quizzler> createState() => _QuizzlerState();
}

class _QuizzlerState extends State<Quizzler> {
  List<bool> answers = [];

  @override
  Widget build(BuildContext context) {
    void handleAnswer(bool userAnswer) {
      bool correctAnswer = quizBrain.getCorrectAnswer();

      if (quizBrain.isLastQuestion()) {
        void onAlertClose() {
          Navigator.pop(context);

          setState(() {
            quizBrain.reset();
            answers.clear();
          });
        }

        Alert(
          context: context,
          title: "Finished!",
          desc: "You've reached the end of the quiz.",
          closeFunction: onAlertClose,
          buttons: [
            DialogButton(
              child: Text(
                "CANCEL",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: onAlertClose,
            )
          ],
        ).show();
      } else {
        setState(() {
          if (userAnswer == correctAnswer) {
            answers.add(true);
          } else {
            answers.add(false);
          }
        });
        quizBrain.nextQuestion();
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      quizBrain.getQuestionText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnswerButton(
                    "True",
                    Colors.green,
                    onPressed: () {
                      handleAnswer(true);
                    },
                  ),
                  SizedBox(height: 16),
                  AnswerButton(
                    "False",
                    Colors.red,
                    onPressed: () {
                      handleAnswer(false);
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: answers
                        .map((answer) => answer
                            ? Icon(Icons.check, color: Colors.green)
                            : Icon(Icons.close, color: Colors.red))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Quizzler(),
    );
  }
}
