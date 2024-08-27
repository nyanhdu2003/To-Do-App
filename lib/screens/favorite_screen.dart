import 'package:flutter/material.dart';
import 'package:todo_list_app/components/global_variable.dart';
import 'package:todo_list_app/screens/homepage.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  static List<Map<String, dynamic>> selectedFavoriteTasks = [];

  void toggleTask(Map<String, dynamic> task) {
    setState(() {
      if (selectedFavoriteTasks.contains(task)) {
        selectedFavoriteTasks.remove(task);
      } else {
        selectedFavoriteTasks.add(task);
      }
    });
  }

  void deleteSelectedTasks() {
    setState(() {
      Global.selectedTasks.removeWhere((task) => selectedFavoriteTasks.contains(task));
      selectedFavoriteTasks.clear();
    });
    Homepage.tasksStateKey.currentState?.updateState(); // Update the state of the Homepage
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Favorite Tasks'),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              onPressed: deleteSelectedTasks,
              icon: const Icon(Icons.delete, color: Colors.black),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: Global.selectedTasks.length,
          itemBuilder: (context, index) {
            final task = Global.selectedTasks[index];
            final isSelected = selectedFavoriteTasks.contains(task);
            final hasTask = selectedFavoriteTasks.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 5, horizontal: 30.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 5),
                          color: Colors.lightBlue,
                          spreadRadius: 3,
                          blurRadius: 2,
                        ),
                      ],
                      color: isSelected ? Colors.blue[100] : Colors.white,
                    ),
                    child: ListTile(
                      onTap: () => toggleTask(task),
                      title: Text(
                        task['task'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(task['date'].toString()),
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
