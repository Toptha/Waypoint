import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/interview_model.dart';
import 'data/interviewer_controller.dart';

class EvaluationScreen extends ConsumerStatefulWidget {
  final String interviewId;
  final InterviewModel interview;

  const EvaluationScreen({super.key, required this.interviewId, required this.interview});

  @override
  ConsumerState<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends ConsumerState<EvaluationScreen> {
  final _feedbackController = TextEditingController();
  int _rating = 3;

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) return;
    
    await ref.read(interviewFeedbackControllerProvider.notifier).submitFeedback(
          interviewId: widget.interviewId,
          feedback: _feedbackController.text,
          rating: _rating,
        );
        
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Check if locked
    final hasSubmittedAsync = ref.watch(interviewFeedbackStatusProvider(widget.interviewId));
    final appDetailsAsync = ref.watch(interviewApplicationProvider(widget.interview.applicationId));
    final isLoading = ref.watch(interviewFeedbackControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Candidate Evaluation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Application Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: appDetailsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text('Error loading app details: $e'),
                  data: (app) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Applicant ID: ${app.applicantId}', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text('View Candidate Resume'),
                        onPressed: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('Open PDF: ${app.resumeUrl}'))
                           );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Evaluation Form', style: Theme.of(context).textTheme.titleLarge),
            
            // Render conditionally based on submission lock
            hasSubmittedAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
              data: (hasSubmitted) {
                if (hasSubmitted || widget.interview.status == 'completed') {
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade50,
                    child: const Row(
                      children: [
                        Icon(Icons.lock, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(child: Text('Feedback has already been submitted and is locked.')),
                      ],
                    ),
                  );
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text('Rating (1-5): $_rating', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: _rating.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rating.toString(),
                      onChanged: (val) {
                        setState(() => _rating = val.toInt());
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Detailed Feedback',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitFeedback,
                        child: isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) 
                            : const Text('Submit & Lock Feedback'),
                      ),
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
