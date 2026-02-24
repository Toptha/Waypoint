import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/hr_controller.dart';
import 'data/hr_repository.dart';
import '../../../models/job_listing_model.dart';
import '../../../models/application_model.dart';

class HrJobDetailScreen extends ConsumerWidget {
  final String jobId;

  const HrJobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get job list
    final jobsAsync = ref.watch(allJobsProvider);
    final appsAsync = ref.watch(jobApplicationsProvider(jobId));

    return jobsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (jobs) {
        final job = jobs.firstWhere(
          (j) => j.id == jobId, 
          orElse: () => JobListingModel(id: '', title: 'Not Found', description: '', department: '', status: '', createdAt: DateTime.now())
        );

        if (job.id.isEmpty) {
          return const Scaffold(body: Center(child: Text('Job not found')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(job.title),
            actions: [
              // Toggle Job Status
              IconButton(
                icon: Icon(job.status == 'open' ? Icons.lock_outline : Icons.lock_open),
                tooltip: job.status == 'open' ? 'Close Job' : 'Reopen Job',
                onPressed: () {
                  final newStatus = job.status == 'open' ? 'closed' : 'open';
                  ref.read(jobUpdateControllerProvider.notifier).updateJobStatus(job.id, newStatus);
                },
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Applications', style: Theme.of(context).textTheme.titleLarge),
              ),
              Expanded(
                child: appsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                  data: (apps) {
                    if (apps.isEmpty) {
                      return const Center(child: Text('No applications yet.'));
                    }
                    return ListView.builder(
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        final app = apps[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text('Applicant: ${app.applicantId.substring(0,8)}...'),
                            subtitle: Text('Status: ${app.status.toUpperCase()}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) {
                                if (action == 'view_resume') {
                                  // In a real app, open URL launcher or PDF viewer
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Resume URL: ${app.resumeUrl}')));
                                } else if (action == 'assign_interviewer') {
                                  _showAssignInterviewerDialog(context, ref, app);
                                } else if (['rejected', 'hired'].contains(action)) {
                                  // Direct update via HrRepository
                                  // Skipping explicit controller generation for brevity, directly call repo:
                                  ref.read(hrRepositoryProvider).updateApplicationStatus(app.id, action).then((_) {
                                    ref.invalidate(jobApplicationsProvider(jobId));
                                  });
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'view_resume', child: Text('View Resume Link')),
                                if (app.status == 'pending' || app.status == 'reviewing')
                                  const PopupMenuItem(value: 'assign_interviewer', child: Text('Assign Interviewer')),
                                if (app.status != 'hired' && app.status != 'rejected')
                                  const PopupMenuItem(value: 'rejected', child: Text('Reject Candidate')),
                                if (app.status != 'hired' && app.status != 'rejected')
                                  const PopupMenuItem(value: 'hired', child: Text('Mark as Hired')),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showAssignInterviewerDialog(BuildContext context, WidgetRef ref, ApplicationModel app) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AssignInterviewerDialog(applicationId: app.id, jobId: jobId,),
    );
  }
}

class _AssignInterviewerDialog extends ConsumerStatefulWidget {
  final String applicationId;
  final String jobId;

  const _AssignInterviewerDialog({required this.applicationId, required this.jobId});

  @override
  ConsumerState<_AssignInterviewerDialog> createState() => _AssignInterviewerDialogState();
}

class _AssignInterviewerDialogState extends ConsumerState<_AssignInterviewerDialog> {
  String? _selectedInterviewerId;
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));

  Future<void> _submit() async {
    if (_selectedInterviewerId == null) return;

    await ref.read(applicationUpdateControllerProvider.notifier).assignInterviewer(
          widget.applicationId,
          _selectedInterviewerId!,
          _scheduledDate,
        );
    
    // Refresh the application list
    ref.invalidate(jobApplicationsProvider(widget.jobId));
    
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final interviewersAsync = ref.watch(availableInterviewersProvider);
    final isLoading = ref.watch(applicationUpdateControllerProvider).isLoading;

    return AlertDialog(
      title: const Text('Assign Interviewer'),
      content: interviewersAsync.when(
        loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
        error: (e, st) => Text('Error: $e'),
        data: (interviewers) {
          if (interviewers.isEmpty) return const Text('No users with role "interviewer" found.');
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Interviewer'),
                value: _selectedInterviewerId,
                items: interviewers.map((user) {
                  return DropdownMenuItem(value: user.id, child: Text(user.fullName));
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedInterviewerId = val);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text('Date: ${_scheduledDate.month}/${_scheduledDate.day}'),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _scheduledDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _scheduledDate = date);
                  }
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(onPressed: isLoading ? null : () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: isLoading || _selectedInterviewerId == null ? null : _submit,
          child: isLoading 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator()) 
              : const Text('Assign'),
        ),
      ],
    );
  }
}
