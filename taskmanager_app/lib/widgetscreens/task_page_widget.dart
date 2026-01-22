import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taskmanager_app/utils/classes.dart';
import 'package:http/http.dart' as http;

class TaskPageWidget extends StatefulWidget {
  const TaskPageWidget({super.key});

  @override
  State<TaskPageWidget> createState() => _TaskPageWidgetState();
}

class _TaskPageWidgetState extends State<TaskPageWidget> {
  final String getTaskUrl = dotenv.env['TASK_URL']!;

  Future<PaginatedTasks> _fetchTasks({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$getTaskUrl?page=$page'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return PaginatedTasks.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  List<Task> tasks = [];
  String? nextPageUrl;
  bool _isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final paginatedTasks = await _fetchTasks(page: currentPage);

      setState(() {
        tasks.addAll(paginatedTasks.results);
        nextPageUrl = paginatedTasks.next;
        currentPage++;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load tasks: $e")));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length + (nextPageUrl != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < tasks.length) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('Category: ${task.category}'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: loadTasks,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Load More"),
            ),
          );
        }
      },
    );
  }
}
