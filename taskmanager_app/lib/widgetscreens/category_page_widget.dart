import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanager_app/utils/classes.dart';

class CategoryPageWidget extends StatefulWidget {
  const CategoryPageWidget({super.key});

  @override
  State<CategoryPageWidget> createState() => _CategoryPageWidgetState();
}

class _CategoryPageWidgetState extends State<CategoryPageWidget> {
  final String categoryUrl = dotenv.env['CATEGORY_URL']!;
  List<Category> categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  // LOAD CATEGORIES
  Future<void> loadCategories() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(categoryUrl),
        headers: {
          "Authorization": "Bearer ${AuthService.accessToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Category> loadedCategories = (data['results'] as List)
            .map((e) => Category.fromJson(e))
            .toList();
        setState(() => categories = loadedCategories);
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  // CREATE CATEGORY
  Future<void> createCategory(String name) async {
    try {
      final response = await http.post(
        Uri.parse(categoryUrl),
        headers: {
          "Authorization": "Bearer ${AuthService.accessToken}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode == 201) {
        await loadCategories();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Category created")));
      } else {
        throw Exception("Failed to create category");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // UPDATE CATEGORY
  Future<void> updateCategory(int id, String name) async {
    try {
      final response = await http.put(
        Uri.parse("$categoryUrl$id/"),
        headers: {
          "Authorization": "Bearer ${AuthService.accessToken}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode == 200) {
        await loadCategories();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Category updated")));
      } else {
        throw Exception("Failed to update category");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // DELETE CATEGORY
  Future<void> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$categoryUrl$id/"),
        headers: {
          "Authorization": "Bearer ${AuthService.accessToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 204) {
        await loadCategories();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Category deleted")));
      } else {
        throw Exception("Failed to delete category");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // MODAL SHEET FOR CREATE/EDIT
  void openEditCategory({Category? category}) {
    final nameCtrl = TextEditingController(text: category?.name ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category == null ? "Create Category" : "Edit Category",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;

                  if (category == null) {
                    await createCategory(name);
                  } else {
                    await updateCategory(category.id, name);
                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: Text(category == null ? "Create" : "Save Changes"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(category.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => openEditCategory(category: category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteCategory(category.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditCategory(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
