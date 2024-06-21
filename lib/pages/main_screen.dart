// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:to_do_app/services/firestore_services.dart';

// import 'package:to_do_app/utils/todo_list.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//   @override
//   State<MainScreen> createState() {
//     return _MainScreen();
//   }
// }

// class _MainScreen extends State<MainScreen> {

//   final FirestoreService firestoreService = FirestoreService();
//   final _controler = TextEditingController();
//   List toDoList = [];

//   void checkBoxChanged(int index) {
//     setState(() {
//       toDoList[index][1] = !toDoList[index][1];
//     });
//   }

//   void saveNewTask() {
//     setState(() {
//       toDoList.add([_controler.text, false]);
//       _controler.clear();
//     });
//   }

//   void deleteTask(int index) {
//     setState(() {
//       toDoList.removeAt(index);
//     });
//   }

//   @override
//   Widget build(context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.deepPurple.shade200,
//         appBar: AppBar(
//           title: const Text("Todo App",
//               style: TextStyle(
//                   color: Color.fromARGB(255, 236, 236, 236),
//                   fontWeight: FontWeight.bold)),
//           toolbarHeight: 40,
//           backgroundColor: Colors.deepPurple,
//         ),

//         body: StreamBuilder<QuerySnapshot> (
//           stream: firestoreService.getNotesStream(),
//           builder: (context,snapshot){

//           },
//         ),

//         ListView.builder(
//             padding: const EdgeInsets.only(
//               top: 20,
//               left: 20,
//               right: 20,
//               bottom: 0,
//             ),
//             itemCount: toDoList.length,
//             itemBuilder: (BuildContext context, int index) {
//               return TodoList(
//                 taskName: toDoList[index][0],
//                 taskCompleted: toDoList[index][1],
//                 onChanged: (value) => checkBoxChanged(index),
//                 deleteFunction: (context) => deleteTask(index),
//               );
//             }),
//         floatingActionButton: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: TextField(
//                     controller: _controler,
//                     decoration: InputDecoration(
//                       hintText: 'Add new task',
//                       filled: true,
//                       fillColor: Colors.deepPurple.shade200,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.deepPurple),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.deepPurple),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               FloatingActionButton(
//                 onPressed: () {
//                   firestoreService.addNote(_controler.text, false);
//                   _controler.clear();
//                 },
//                 child: const Icon(Icons.add),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:to_do_app/services/firestore_services.dart';
import 'package:to_do_app/utils/todo_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _controller = TextEditingController();

  // Method to handle checkbox changes and update Firestore
  void checkBoxChanged(String docId, bool currentStatus) {
    firestoreService.updateNote(docId, !currentStatus).then((_) {
      setState(() {});
    });
  }

  // Method to save a new task and update Firestore
  void saveNewTask() {
    firestoreService.addNote(_controller.text, false).then((_) {
      setState(() {
        _controller.clear();
      });
    });
  }

  // Method to delete a task from Firestore
  void deleteTask(String docId) {
    firestoreService.deleteNote(docId).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple.shade200,
        appBar: AppBar(
          title: const Text(
            "Todo App",
            style: TextStyle(
                color: Color.fromARGB(255, 236, 236, 236),
                fontWeight: FontWeight.bold),
          ),
          toolbarHeight: 40,
          backgroundColor: Colors.deepPurple,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(), // Corrected method name
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            final toDoList = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 0,
              ),
              itemCount: toDoList.length,
              itemBuilder: (BuildContext context, int index) {
                final task = toDoList[index];
                return TodoList(
                  taskName: task['note'], // Get task name from Firestore
                  taskCompleted: task[
                      'isDone'], // Get task completion status from Firestore
                  onChanged: (value) => checkBoxChanged(
                      task.id, task['isDone']), // Update task completion status
                  deleteFunction: (context) =>
                      deleteTask(task.id), // Delete task
                );
              },
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add new task',
                      filled: true,
                      fillColor: Colors.deepPurple.shade200,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: saveNewTask, // Save new task to Firestore
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
