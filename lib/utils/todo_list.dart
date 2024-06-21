
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class TodoList extends StatelessWidget {
  const TodoList({
    required this.taskName,
    required this.taskCompleted,
    required this.docId,
    super.key,
    this.onChanged,
    this.deleteFunction,
    required this.updateFunction,
  });

  final String taskName;
  final bool taskCompleted;
  final String docId;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(String, String) updateFunction;

  void openEditBox(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: taskName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter new task name',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Save'),
            onPressed: () {
              updateFunction(docId,
                  _controller.text); // Pass the new note to updateFunction
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
              backgroundColor: Colors.red.shade300,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.deepPurple,
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                checkColor: Colors.black,
                activeColor: Colors.white,
                side: const BorderSide(
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  taskName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => openEditBox(context),
                icon: Icon(Icons.edit),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

