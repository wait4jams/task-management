import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskService {
  static const String _baseUrl = 'https://mytodo-a9818-default-rtdb.firebaseio.com/';

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  Future<List<Task>> fetchTasks() async {
    final url = Uri.parse('$_baseUrl/tasks/$_userId.json');
    final res = await http.get(url);
    final data = json.decode(res.body);

    if (data == null) return [];

    return (data as Map<String, dynamic>).entries
        .map((e) => Task.fromJson(e.key, e.value))
        .toList();
  }

  Future<void> addTask(Task task) async {
    final url = Uri.parse('$_baseUrl/tasks/$_userId.json');
    await http.post(url, body: json.encode(task.toJson()));
  }

  Future<void> updateTask(Task task) async {
    final url = Uri.parse('$_baseUrl/tasks/$_userId/${task.id}.json');
    await http.patch(url, body: json.encode(task.toJson()));
  }

  Future<void> deleteTask(String taskId) async {
    final url = Uri.parse('$_baseUrl/tasks/$_userId/$taskId.json');
    await http.delete(url);
  }
}
