import 'package:flutter/material.dart';
import 'package:to_do_list/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    content: Container(
      height: 128, // Increase height if needed
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Create new task",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0), // Reduce padding if needed
                  child: MyButton(onPressed: onSave, text: "Save"),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0), // Reduce padding if needed
                  child: MyButton(onPressed: onCancel, text: "Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
}