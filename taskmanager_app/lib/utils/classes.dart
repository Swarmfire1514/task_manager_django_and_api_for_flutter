import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? accessToken;

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
  }
}

// ---------------- Task Models ----------------

class Task {
  int id;
  String title;
  String description;
  String status;
  String priority;
  DateTime dueDate;
  String categoryName; // for display
  int categoryId;      // for API requests

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.categoryName,
    required this.categoryId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      status: json['status'],
      priority: json['priority'],
      dueDate: DateTime.parse(json['due_date']),
      categoryName: json['category_name'] ?? '',
      categoryId: json['category'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "status": status,
      "priority": priority,
      "due_date": dueDate.toIso8601String(),
      "category": categoryId,
    };
  }
}


class PaginatedTasks {
  final int count;
  final String? next;
  final String? previous;
  final List<Task> results;

  PaginatedTasks({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PaginatedTasks.fromJson(Map<String, dynamic> json) {
    return PaginatedTasks(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => Task.fromJson(e))
          .toList(),
    );
  }
}

// ---------------- Category Models ----------------

class Category {
  final int id;
  String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}


// ---------------- ActivityLog Models ----------------

class ActivityLog {
  final int id;
  final String username;
  final String action;
  final int? category;
  final String? categoryTitle;
  final int? task;
  final String? taskTitle;
  final DateTime timestamp;

  ActivityLog({
    required this.id,
    required this.username,
    required this.action,
    this.category,
    this.categoryTitle,
    this.task,
    this.taskTitle,
    required this.timestamp,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'],
      username: json['username'],
      action: json['action'],
      category: json['category'],
      categoryTitle: json['category_title'],
      task: json['task'],
      taskTitle: json['task_title'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ActivityLogPaginated {
  final int count;
  final String? next;
  final String? previous;
  final List<ActivityLog> results;

  ActivityLogPaginated({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ActivityLogPaginated.fromJson(Map<String, dynamic> json) {
    return ActivityLogPaginated(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List).map((e) => ActivityLog.fromJson(e)).toList(),
    );
  }
}
