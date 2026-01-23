import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:taskmanager_app/utils/classes.dart';

class ActivityLogWidget extends StatefulWidget {
  const ActivityLogWidget({super.key});

  @override
  State<ActivityLogWidget> createState() => _ActivityLogWidgetState();
}

class _ActivityLogWidgetState extends State<ActivityLogWidget> {
  final String getLogUrl = dotenv.env['ACTIVITY_LOG_URL']!;
  List<ActivityLog> logs = [];
  String? nextPageUrl;
  bool _isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<ActivityLogPaginated> fetchLogs(int page) async {
    final response = await http.get(
      Uri.parse("$getLogUrl?page=$page"),
      headers: {
        "Authorization": "Bearer ${AuthService.accessToken}",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return ActivityLogPaginated.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load activity logs");
    }
  }

  Future<void> loadLogs() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final data = await fetchLogs(currentPage);
      setState(() {
        logs.addAll(data.results);
        nextPageUrl = data.next;
        currentPage++;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: logs.length + (nextPageUrl != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < logs.length) {
          final log = logs[index];

          // Build the dynamic description
          final targetType = log.category == null ? "task" : "category";
          final targetTitle =
              log.categoryTitle ?? log.taskTitle ?? "No title";

          final description =
              "${log.username} has ${log.action} the $targetType with title '$targetTitle'";

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(description),
              subtitle:
                  Text(DateFormat.yMMMd().add_jm().format(log.timestamp)),
            ),
          );
        }

        // Load More Button
        return Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: loadLogs,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Load More"),
          ),
        );
      },
    );
  }
}