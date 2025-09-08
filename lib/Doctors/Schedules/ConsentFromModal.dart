import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';

class ConsentFormScreen extends StatelessWidget {
  final Map<String, dynamic> consentFormData;

  const ConsentFormScreen({Key? key, required this.consentFormData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String serviceName =
        consentFormData['data']?['subServiceName'] ?? "Consent Form";
    final List<dynamic> sections =
        consentFormData['data']?['consentFormQuestions'] ?? [];

    return Scaffold(
      appBar: CommonHeader(
        title: serviceName,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                final heading = section['heading'] ?? '';
                final questions = section['questionsAndAnswers'] ?? [];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(
                      heading,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                    children: List.generate(questions.length, (qIndex) {
                      final question = questions[qIndex]['question'] ?? '';
                      final answer = questions[qIndex]['answer'] ?? false;

                      return ListTile(
                        leading: Icon(
                          answer
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: answer ? Colors.green : Colors.grey,
                        ),
                        title: Text(question),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          // ✅ Move note above FAB
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 16, 16, 72), // <-- space for FAB
            child: Text(
              "By proceeding, you acknowledge that you have read, understood, "
              "and accepted the above consent points.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
