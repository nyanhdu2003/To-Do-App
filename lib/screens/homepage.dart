import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/components/global_variable.dart';
import 'package:todo_list_app/components/menubar.dart';


class Homepage extends StatelessWidget {
   const Homepage({super.key});

  // GlobalKey for accessing _TasksState
static final GlobalKey<TasksState> tasksStateKey = GlobalKey<TasksState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  Menu(contextHome: context,),
      appBar: AppBar(
        title: const Text('To-Do List Home'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      // Để phần nội dung của màn hình hiển thị phía sau AppBar
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Tasks(
              key: tasksStateKey, // Assign GlobalKey to Tasks widget
            ),
          ),
        ],
      ),
    );
  }
}

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => TasksState();
}

class TasksState extends State<Tasks> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  DateTime? _selectedDate;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Method để phân chia 3 khung thời gian: Morning, Afternoon, Evening
  Map<String, List<Map<String, dynamic>>> classifyTasksByTime(
      List<Map<String, dynamic>> tasks) {
    final Map<String, List<Map<String, dynamic>>> classifiedTasks = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
    };

    // Phân chia các task thành các khung giờ tương ứng cho từng ngày
    for (var task in tasks) {
      DateTime taskDateTime = task['date'] ?? DateTime.now();

      // Xác định giới hạn thời gian cho ngày của task
      final DateTime morningEnd = DateTime(taskDateTime.year, taskDateTime.month, taskDateTime.day, 12);
      final DateTime afternoonEnd = DateTime(taskDateTime.year, taskDateTime.month, taskDateTime.day, 18);

      if (taskDateTime.isBefore(morningEnd)) {
        classifiedTasks['Morning']!.add(task);
      } else if (taskDateTime.isBefore(afternoonEnd)) {
        classifiedTasks['Afternoon']!.add(task);
      } else {
        classifiedTasks['Evening']!.add(task);
      }
    }

    // Sắp xếp tasks trong mỗi khung thời gian theo ngày
    classifiedTasks.forEach((key, value) {
      value.sort(
              (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    });

    return classifiedTasks;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
              picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  void addTask() {
    setState(() {
      if (_controller.text.isNotEmpty && _selectedDate != null) {
        final RegExp specialCharacters = RegExp(r'^[a-zA-Z0-9 ]*$');

        if (!specialCharacters.hasMatch(_controller.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Tasks cannot contain special characters.')
            ),
          );
        } else if (tasks.any((task) =>
        task['task'] == _controller.text &&
            task['date'] == _selectedDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The task already exists, enter another task')
            ),
          );
        } else {
          tasks.add({
            'task': _controller.text,
            'date': _selectedDate,
            'formattedDate': DateFormat('yyyy-MM-dd hh:mm').format(_selectedDate!)
          });
          tasks.sort((a, b) =>
              (a['date'] as DateTime).compareTo(b['date'] as DateTime));
          _controller.clear();
          _selectedDate = null;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter your task today task and select time!'),
        ));
      }
    });
  }

  void toggleTask(Map<String, dynamic> task) {
    if (Global.selectedTasks.contains(task)) {
      Global.selectedTasks.remove(task);
    } else {
      Global.selectedTasks.add(task);
    }
    setState(() {});
  }

  void showCompleteDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Complete Task'),
          content: const Text('Have you completed this task?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.remove(task);
                });
                Navigator.of(context).pop(); // Đóng hộp thoại hiện tại
                showPraiseDialog(); // Hiện hộp thoại khen ngợi
              },
              child: const Text('Complete'),
            ),
            TextButton(
              onPressed: () {
                showDeleteConfirmationDialog(
                    task); // Hiện hộp thoại xác nhận xóa
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showPraiseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Great Job!'),
          content: const Text('You did a great job completing this task!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại khen ngợi
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.remove(task);
                  Navigator.of(context).pop();
                });

                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại xác nhận
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Classify tasks into time frames
    Map<String, List<Map<String, dynamic>>> classifiedTasks =
        classifyTasksByTime(tasks);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: ListView(
              children: [
                _buildTaskSection('Morning', classifiedTasks['Morning'] ?? []),
                _buildTaskSection(
                    'Afternoon', classifiedTasks['Afternoon'] ?? []),
                _buildTaskSection('Evening', classifiedTasks['Evening'] ?? []),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20
                          ),
                          labelText: 'Enter your task here',
                          labelStyle: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                            ),
                            onPressed: () => _selectDateTime(context),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.black)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.black)
                          )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: addTask,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Map<String, dynamic>> tasks) {
    return tasks.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: tasks.map((task) {
            final isSelected = Global.selectedTasks.contains(task);
            return ListTile(
              onTap: () => toggleTask(task),
              onLongPress: () => showCompleteDialog(task),
              title: Text(
                task['task'],
                style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                task['formattedDate'],
                style: const TextStyle(color: Colors.black),
              ),
              leading: isSelected
                  ? const Icon(Icons.star, color: Colors.yellowAccent)
                  : const Icon(Icons.star_border_outlined),
            );
          }).toList(),
        ),
      ],
    )
        : const SizedBox();
  }
}
