// import 'package:flutter/material.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_list_app/theme_provider.dart';
// import 'menubar.dart';
//
// class Homepage extends StatelessWidget {
//   const Homepage({super.key});
//
//   // GlobalKey for accessing _TasksState
//   static final GlobalKey<_TasksState> _tasksStateKey = GlobalKey<_TasksState>();
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     var isDark = themeProvider.themeMode == ThemeMode.dark;
//
//     return SafeArea(
//       child: Scaffold(
//         body: MaterialApp(
//           theme: ThemeData(
//             brightness: Brightness.light,
//             primarySwatch: Colors.blue,
//             inputDecorationTheme: InputDecorationTheme(
//               fillColor: Colors.white,
//               filled: true,
//               labelStyle: const TextStyle(color: Colors.black),
//               hintStyle: const TextStyle(color: Colors.black54),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//                 borderSide: const BorderSide(color: Colors.black),
//               ),
//             ),
//           ),
//           darkTheme: ThemeData(
//             brightness: Brightness.dark,
//             primarySwatch: Colors.blue,
//             inputDecorationTheme: InputDecorationTheme(
//               fillColor: Colors.black54,
//               filled: true,
//               labelStyle: const TextStyle(color: Colors.white),
//               hintStyle: const TextStyle(color: Colors.white54),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//                 borderSide: const BorderSide(color: Colors.white),
//               ),
//             ),
//           ),
//           themeMode: themeProvider.themeMode,
//           home: SafeArea(
//             child: Scaffold(
//               drawer: const Menu(),
//               appBar: AppBar(
//                 title: const Text('To-Do List Home'),
//                 backgroundColor: Colors.transparent,
//                 // Đặt màu nền trong suốt cho AppBar
//                 elevation: 0,
//                 // Loại bỏ độ nổi của AppBar
//                 actions: [
//                   IconButton(
//                     onPressed: () {
//                       themeProvider.toggleTheme(!isDark);
//                     },
//                     icon:
//                     Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
//                   )
//                 ],
//               ),
//               extendBodyBehindAppBar: true,
//               // Để phần nội dung của màn hình hiển thị phía sau AppBar
//               body: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('images/bg.webp'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Tasks(
//                       key: _tasksStateKey, // Assign GlobalKey to Tasks widget
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           debugShowCheckedModeBanner: false,
//         ),
//       ),
//     );
//   }
// }
//
// class Tasks extends StatefulWidget {
//   const Tasks({Key? key}) : super(key: key);
//
//   @override
//   State<Tasks> createState() => _TasksState();
// }
//
// class _TasksState extends State<Tasks> {
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> tasks = [];
//   List<Map<String, dynamic>> selectedTasks = [];
//   DateTime? _selectedDate;
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // Method để phân chia 3 khung thời gian: Morning, Afternoon, Evening
//   Map<String, List<Map<String, dynamic>>> classifyTasksByTime(
//       List<Map<String, dynamic>> tasks) {
//     final Map<String, List<Map<String, dynamic>>> classifiedTasks = {
//       'Morning': [],
//       'Afternoon': [],
//       'Evening': [],
//     };
//
//     // Khai báo giới hạn của từng khung thời gian
//     final DateTime morningEnd = DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);
//     final DateTime afternoonEnd = DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day, 18);
//
//     // Phân vùng các task thành các khung giờ tương ứng
//     for (var task in tasks) {
//       DateTime taskDateTime = task['date'] ?? DateTime.now();
//       if (taskDateTime.isBefore(morningEnd)) {
//         classifiedTasks['Morning']!.add(task);
//       } else if (taskDateTime.isBefore(afternoonEnd)) {
//         classifiedTasks['Afternoon']!.add(task);
//       } else {
//         classifiedTasks['Evening']!.add(task);
//       }
//     }
//
//     // Sắp xếp tasks trong mỗi khung thời gian theo ngày
//     classifiedTasks.forEach((key, value) {
//       value.sort(
//               (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
//     });
//
//     return classifiedTasks;
//   }
//
//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       final TimeOfDay? time = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//       if (time != null) {
//         setState(() {
//           _selectedDate = DateTime(
//               picked.year, picked.month, picked.day, time.hour, time.minute);
//         });
//       }
//     }
//   }
//
//   void addTask() {
//     setState(() {
//       if (_controller.text.isNotEmpty && _selectedDate != null) {
//         final RegExp specialCharacters = RegExp(r'^[a-zA-Z0-9 ]*$');
//
//         if (!specialCharacters.hasMatch(_controller.text)) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('Tasks cannot contain special characters.')),
//           );
//         } else if (tasks.any((task) =>
//         task['task'] == _controller.text &&
//             task['date'] == _selectedDate)) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('The task already exists, enter another task')),
//           );
//         } else {
//           tasks.add({'task': _controller.text, 'date': _selectedDate});
//           tasks.sort((a, b) =>
//               (a['date'] as DateTime).compareTo(b['date'] as DateTime));
//           _controller.clear();
//           _selectedDate = null;
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Enter your task today task and select time!'),
//         ));
//       }
//     });
//   }
//
//   void toggleTask(Map<String, dynamic> task) {
//     if (selectedTasks.contains(task)) {
//       selectedTasks.remove(task);
//     } else {
//       selectedTasks.add(task);
//     }
//     setState(() {});
//   }
//
//   void showCompleteDialog(Map<String, dynamic> task) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Complete Task'),
//           content: const Text('Have you completed this task?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   tasks.remove(task);
//                 });
//                 Navigator.of(context).pop(); // Đóng hộp thoại hiện tại
//                 showPraiseDialog(); // Hiện hộp thoại khen ngợi
//               },
//               child: const Text('Complete'),
//             ),
//             TextButton(
//               onPressed: () {
//                 showDeleteConfirmationDialog(
//                     task); // Hiện hộp thoại xác nhận xóa
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showPraiseDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Great Job!'),
//           content: const Text('You did a great job completing this task!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng hộp thoại khen ngợi
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showDeleteConfirmationDialog(Map<String, dynamic> task) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Task'),
//           content: const Text('Are you sure you want to delete this task?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   tasks.remove(task);
//                   Navigator.of(context).pop();
//                 });
//
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng hộp thoại xác nhận
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Classify tasks into time frames
//     Map<String, List<Map<String, dynamic>>> classifiedTasks =
//     classifyTasksByTime(tasks);
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             flex: 4,
//             child: ListView(
//               children: [
//                 _buildTaskSection('Morning', classifiedTasks['Morning'] ?? []),
//                 _buildTaskSection(
//                     'Afternoon', classifiedTasks['Afternoon'] ?? []),
//                 _buildTaskSection('Evening', classifiedTasks['Evening'] ?? []),
//               ],
//             ),
//           ),
//           SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: TextField(
//                         controller: _controller,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 20),
//                           labelText: 'Enter your task here',
//                           labelStyle: const TextStyle(
//                             fontSize: 20,
//                           ),
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.calendar_today, color: Colors.black87,),
//                             onPressed: () => _selectDateTime(context),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.black, width: 1),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: addTask,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTaskSection(String title, List<Map<String, dynamic>> tasks) {
//     return tasks.isNotEmpty
//         ? Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Text(
//             title,
//             style: const TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Column(
//           children: tasks.map((task) {
//             final isSelected = selectedTasks.contains(task);
//             return ListTile(
//               onTap: () => toggleTask(task),
//               onLongPress: () => showCompleteDialog(task),
//               title: Text(task['task']),
//               subtitle: Text(task['date'].toString()),
//               leading: isSelected
//                   ? const Icon(Icons.check_circle, color: Colors.green)
//                   : const Icon(Icons.circle_outlined),
//             );
//           }).toList(),
//         ),
//       ],
//     )
//         : const SizedBox();
//   }
// }
