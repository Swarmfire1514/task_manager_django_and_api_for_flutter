import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:taskmanager_app/utils/classes.dart'; // Task, Category, PaginatedTasks, AuthService

class TaskPageWidget extends StatefulWidget {
  const TaskPageWidget({super.key});

  @override
  State<TaskPageWidget> createState() => _TaskPageWidgetState();
}

class _TaskPageWidgetState extends State<TaskPageWidget> {
  final String getTaskUrl = dotenv.env['TASK_URL']!;
  final String getCategoryUrl = dotenv.env['CATEGORY_URL']!;

  List<Task> tasks = [];
  List<Category> categories = [];
  String? nextPageUrl;
  bool _isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadTasks();
  }

  // Load categories from API
  Future<void> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse(getCategoryUrl),
        headers: {
          "Authorization": "Bearer ${AuthService.accessToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        setState(() {
          categories = results
              .map((e) => Category(id: e['id'], name: e['name']))
              .toList();
        });
      }
    } catch (_) {}
  }

  // Fetch paginated tasks
  Future<PaginatedTasks> fetchTasks(int page) async {
    final response = await http.get(
      Uri.parse("$getTaskUrl?page=$page"),
      headers: {
        "Authorization": "Bearer ${AuthService.accessToken}",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return PaginatedTasks.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  Future<void> loadTasks() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final data = await fetchTasks(currentPage);
      setState(() {
        tasks.addAll(data.results);
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

  Future<void> updateTask(Task task) async {
    await http.patch(
      Uri.parse("$getTaskUrl${task.id}/"),
      headers: {
        "Authorization": "Bearer ${AuthService.accessToken}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "title": task.title,
        "description": task.description,
        "status": task.status,
        "priority": task.priority,
        "due_date": DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate),
        "category": task.categoryId,
      }),
    );
  }

  Future<void> deleteTask(int taskId) async {
    try {
      final response = await http.delete(
        Uri.parse("$getTaskUrl$taskId/"),
        headers: {
          "Authorization": "Bearer ${AuthService.accessToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 204) {
        throw Exception("Failed to delete task");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(getTaskUrl),
      headers: {
        "Authorization": "Bearer ${AuthService.accessToken}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "title": task.title,
        "description": task.description,
        "status": task.status,
        "priority": task.priority,
        "due_date": DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate),
        "category": task.categoryId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      setState(() {
        tasks.insert(0, Task.fromJson(jsonDecode(response.body)));
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task created successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create task"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Open bottom sheet for create/edit
  void openEditTask(Task task, {bool isNew = false}) {
    final titleCtrl = TextEditingController(text: task.title);
    final descriptionCtrl = TextEditingController(text: task.description);
    String status = task.status;
    String priority = task.priority;
    DateTime selectedDate = task.dueDate;
    Category? selectedCategory = categories.firstWhereOrNull(
      (c) => c.name == task.categoryName,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isNew ? "Create Task" : "Edit Task",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextField(
                    controller: descriptionCtrl,
                    maxLines: null,
                    decoration:
                        const InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 12),

                  // Status
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    items: ["pending", "completed"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setModalState(() => status = v!),
                    decoration: const InputDecoration(labelText: "Status"),
                  ),
                  const SizedBox(height: 12),

                  // Priority
                  DropdownButtonFormField<String>(
                    initialValue: priority,
                    items: ["low", "medium", "high"]
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) => setModalState(() => priority = v!),
                    decoration: const InputDecoration(labelText: "Priority"),
                  ),
                  const SizedBox(height: 12),

                  // Category
                  DropdownButtonFormField<Category>(
                    initialValue: selectedCategory,
                    items: categories
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)),
                        )
                        .toList(),
                    onChanged: (v) => setModalState(() => selectedCategory = v),
                    decoration: const InputDecoration(labelText: "Category"),
                  ),
                  const SizedBox(height: 12),

                  // Due Date
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 5),
                        ),
                      );
                      if (pickedDate != null) {
                        setModalState(() => selectedDate = pickedDate);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        initialValue: DateFormat.yMMMd().format(selectedDate),
                        decoration: const InputDecoration(
                          labelText: "Due Date",
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isNew)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Task"),
                                content: const Text(
                                    "Are you sure you want to delete this task?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              await deleteTask(task.id);
                              if (!mounted) return;
                              Navigator.pop(context);
                              setState(() {
                                tasks.remove(task);
                              });
                            }
                          },
                          child: const Text("Delete"),
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          task.title = titleCtrl.text;
                          task.description = descriptionCtrl.text;
                          task.status = status;
                          task.priority = priority;
                          task.dueDate = selectedDate;
                          task.categoryId =
                              selectedCategory?.id ?? task.categoryId;
                          task.categoryName =
                              selectedCategory?.name ?? task.categoryName;

                          if (isNew) {
                            await createTask(task);
                          } else {
                            await updateTask(task);
                          }

                          if (!mounted) return;
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text(isNew ? "Create Task" : "Save Changes"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newTask = Task(
            id: 0,
            title: "",
            description: "",
            status: "pending",
            priority: "low",
            dueDate: DateTime.now(),
            categoryName: "",
            categoryId: 0,
          );
          openEditTask(newTask, isNew: true);
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tasks.length + (nextPageUrl != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < tasks.length) {
            final task = tasks[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status: ${task.status}"),
                    Text("Priority: ${task.priority}"),
                    Text("Due: ${DateFormat.yMMMd().format(task.dueDate)}"),
                    Text("Category: ${task.categoryName}"),
                    Text(
                      task.description.length > 50
                          ? "${task.description.substring(0, 50)}..."
                          : task.description,
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => openEditTask(task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Task"),
                            content: const Text(
                                "Are you sure you want to delete this task?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await deleteTask(task.id);
                          if (!mounted) return;
                          setState(() {
                            tasks.remove(task);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          // Load More Button
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: loadTasks,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Load More"),
            ),
          );
        },
      ),
    );
  }
}
