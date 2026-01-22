class Task {
  final int id;
  final String title;
  final int category;

  Task({required this.id, required this.title, required this.category});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      category: json['category'],
    );
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
          .map((taskJson) => Task.fromJson(taskJson))
          .toList(),
    );
  }
}
