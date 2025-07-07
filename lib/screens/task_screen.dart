import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task; // null means add new task

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    final provider = Provider.of<TaskProvider>(context, listen: false);

    if (widget.task == null) {
      await provider.addTaskWithDescription(title, description);
    } else {
      final updatedTask = widget.task!.copyWith(
        title: title,
        description: description,
      );
      await provider.updateTask(updatedTask);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  void _clearTitle() => _titleController.clear();
  void _clearDescription() => _descController.clear();

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: const OutlineInputBorder(),
                  suffixIcon: _titleController.text.isEmpty
                      ? null
                      : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearTitle,
                    tooltip: 'Clear title',
                  ),
                ),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Please enter a task title' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  border: const OutlineInputBorder(),
                  suffixIcon: _descController.text.isEmpty
                      ? null
                      : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearDescription,
                    tooltip: 'Clear description',
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveTask,
                  child: _isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text(isEditing ? 'Save Changes' : 'Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
