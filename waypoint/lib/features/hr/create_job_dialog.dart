import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/hr_controller.dart';

class CreateJobDialog extends ConsumerStatefulWidget {
  const CreateJobDialog({super.key});

  @override
  ConsumerState<CreateJobDialog> createState() => _CreateJobDialogState();
}

class _CreateJobDialogState extends ConsumerState<CreateJobDialog> {
  final _titleController = TextEditingController();
  final _departmentController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _departmentController.text.isEmpty) return;

    await ref.read(jobCreationControllerProvider.notifier).createJob(
          _titleController.text,
          _descriptionController.text,
          _departmentController.text,
        );
    
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(jobCreationControllerProvider).isLoading;

    return AlertDialog(
      title: const Text('Create Job Listing'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              controller: _departmentController,
              decoration: const InputDecoration(labelText: 'Department'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator()) 
              : const Text('Create'),
        ),
      ],
    );
  }
}
