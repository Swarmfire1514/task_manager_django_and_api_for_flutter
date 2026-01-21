import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Activity Log'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
