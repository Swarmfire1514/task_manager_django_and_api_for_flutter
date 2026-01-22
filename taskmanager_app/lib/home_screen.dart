import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanager_app/auth_screens/login_screen.dart';
import 'package:taskmanager_app/widgetscreens/activity_log_widget.dart';
import 'package:taskmanager_app/widgetscreens/category_page_widget.dart';
import 'package:taskmanager_app/widgetscreens/home_page_widget.dart';
import 'package:taskmanager_app/widgetscreens/profile_page_widget.dart';
import 'package:taskmanager_app/widgetscreens/task_page_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageWidget(),
    const TaskPageWidget(),
    const CategoryPageWidget(),
    const ActivityLogWidget(),
    const ProfilePageWidget(),
  ];

  final String logoutUrl = dotenv.env['LOGOUT_URL']!;

  final List<String> _titles = [
    'Home',
    'Tasks',
    'Categories',
    'Activity Log',
    'Profile',
  ];

  Future<void> _logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh');

    try {
      if (refreshToken != null) {
        final response = await http.post(
          Uri.parse(logoutUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"refresh": refreshToken}),
        );
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"] ?? "Logged out Successfully!"),
            ),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout failed: ${response.statusCode}")),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    }

    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: _currentIndex == 4
            ? [IconButton(icon: Icon(Icons.logout), onPressed: _logoutUser)]
            : null,
      ),

      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Activity Log',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
