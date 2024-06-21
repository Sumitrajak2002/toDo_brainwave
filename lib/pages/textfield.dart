import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  Textfield({super.key, required this.textController});

  final TextEditingController textController;

  @override
  _Textfield createState() => _Textfield();
}

class _Textfield extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
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
    );
  }
}
