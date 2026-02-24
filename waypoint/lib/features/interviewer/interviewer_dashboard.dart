import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../auth/data/auth_controller.dart';
import 'data/interviewer_controller.dart';

class InterviewerDashboard extends ConsumerWidget {
  const InterviewerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interviewsAsync = ref.watch(myInterviewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interviewer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: interviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (interviews) {
          if (interviews.isEmpty) {
            return const Center(child: Text('No interviews assigned to you yet.'));
          }
          
          return ListView.builder(
            itemCount: interviews.length,
            itemBuilder: (context, index) {
              final interview = interviews[index];
              final dateStr = DateFormat.yMMMd().add_jm().format(interview.scheduledAt);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    interview.status == 'completed' ? Icons.check_circle : Icons.event,
                    color: interview.status == 'completed' ? Colors.green : Colors.blue,
                  ),
                  title: Text('Interview slot on: $dateStr'),
                  subtitle: Text('Status: ${interview.status.toUpperCase()}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.push('/interviewer/eval/${interview.id}', extra: interview);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
