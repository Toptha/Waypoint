import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../auth/data/auth_controller.dart';
import 'data/applicant_controller.dart';
import '../../../models/job_listing_model.dart';

class ApplicantDashboard extends ConsumerStatefulWidget {
  const ApplicantDashboard({super.key});

  @override
  ConsumerState<ApplicantDashboard> createState() => _ApplicantDashboardState();
}

class _ApplicantDashboardState extends ConsumerState<ApplicantDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: _selectedIndex == 0 ? const _OpenJobsView() : const _MyApplicationsView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'My Applications'),
        ],
      ),
    );
  }
}

class _OpenJobsView extends ConsumerWidget {
  const _OpenJobsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(openJobsProvider);

    return jobsAsync.when(
      data: (jobs) {
        if (jobs.isEmpty) return const Center(child: Text('No open jobs found.'));
        
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(job.title),
                subtitle: Text('${job.department} \n${job.description}', maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: ElevatedButton(
                  onPressed: () => _applyToJob(context, ref, job),
                  child: const Text('Apply'),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Future<void> _applyToJob(BuildContext context, WidgetRef ref, JobListingModel job) async {
    // Show file picker for resume
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      
      // Ensure widget is mounted before showing dialog
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await ref.read(applicationSubmitControllerProvider.notifier).submitApplication(job.id, file);
        if (!context.mounted) return;
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application Submitted successfully!')));
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _MyApplicationsView extends ConsumerWidget {
  const _MyApplicationsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(myApplicationsProvider);

    return appsAsync.when(
      data: (apps) {
        if (apps.isEmpty) return const Center(child: Text('You have not applied to any jobs yet.'));
        
        return ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('Application for Job: ${app.jobId.substring(0, 8)}...'),
                subtitle: Text('Status: ${app.status.toUpperCase()}'),
                trailing: const Icon(Icons.history),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
