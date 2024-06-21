
import 'package:flutter/material.dart';
import 'package:toDo_brainwave/services/firestore_services.dart';
import 'package:toDo_brainwave/utils/todo_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toDo_brainwave/pages/textfield.dart';

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

  // Method to update a note's text
  void updateNoteText(String docId, String newNote) {
    firestoreService.updateNoteText(docId, newNote).then((_) {
      setState(() {});
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
          stream: firestoreService.getNotesStream(),
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
                  taskName: task['note'],
                  taskCompleted: task['isDone'],
                  docId: task.id,
                  onChanged: (value) =>
                      checkBoxChanged(task.id, task['isDone']),
                  deleteFunction: (context) => deleteTask(task.id),
                  updateFunction: (docId, newNote) =>
                      updateNoteText(docId, newNote),
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
                  child: Textfield(textController: _controller),
                ),
              ),
              FloatingActionButton(
                onPressed: saveNewTask,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

