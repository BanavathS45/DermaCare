import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Utils/ScaffoldMessageSnacber.dart';

class CustomerRating extends StatefulWidget {
  final String status;

  const CustomerRating({super.key, required this.status});

  @override
  State<CustomerRating> createState() => _CustomerRatingState();
}

class _CustomerRatingState extends State<CustomerRating> {
  final TextEditingController feedbackController = TextEditingController();
  bool isLoading = false;
  int selectedRating = 1;

  @override
  void initState() {
    super.initState();
    if (widget.status == "completed") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBottomModal(context);
      });
    }
  }

  // Function to submit feedback
  Future<void> _submitFeedback() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final feedback = feedbackController.text;
    final rating = selectedRating;

    try {
      // Replace with your API URL
      final url = Uri.parse('https://your-api-endpoint.com/submit-feedback');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rating': rating, 'feedback': feedback}),
      );

      if (response.statusCode == 200) {
        // Handle success response
          ScaffoldMessageSnackbar.show(
      context: context,
      message: "Feedback submitted successfully",
      type: SnackbarType.success,
    );
        Navigator.pop(context); // Close the modal after submission
      } else {
        // Handle error response
        ScaffoldMessageSnackbar.show(
      context: context,
      message: "Failed to submit feedback. please try again",
      type: SnackbarType.error,
    );
      }
    } catch (e) {
      ScaffoldMessageSnackbar.show(
      context: context,
      message: "An error occurred. Please try again",
      type: SnackbarType.error,
    );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show success message
  // void showSuccess(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), backgroundColor: Colors.green),
  //   );
  // }

  // Show error message
  // void _showError(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), backgroundColor: Colors.red),
  //   );
  // }

  // Show bottom modal for rating and feedback
  void _showBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Provider Rating',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.teal,
                          size: 30.0,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Provider Feedback (optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Feedback',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Empty container as it automatically triggers the modal
  }
}
