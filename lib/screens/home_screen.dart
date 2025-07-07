import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import 'task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📝 Your Tasks"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Log Out"),
                  content: const Text("Are you sure you want to log out?"),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text("Log Out"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Provider.of<AuthProvider>(context, listen: false).logout();
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (_, tp, __) {
          if (tp.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tp.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No tasks yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: tp.tasks.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) {
              final t = tp.tasks[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: t.isCompleted ? Colors.green : Colors.blue,
                    child: Icon(
                      t.isCompleted ? Icons.check : Icons.task,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    t.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: t.description.isNotEmpty ? Text(t.description) : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete task',
                    onPressed: () => _showDeleteConfirmDialog(context, tp, t),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddTaskScreen(task: t)),
                    );
                  },
                  onLongPress: () => tp.toggleTask(t),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new task',
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, TaskProvider tp, Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              tp.deleteTask(task.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
