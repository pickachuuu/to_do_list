import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatefulWidget {
  final String taskName;
  final bool isSelected;
  final List<String> taskList;
  final Function(bool?)? onChanged;

  const TaskTile({
    super.key,
    required this.taskName,
    required this.isSelected,
    required this.taskList,
    required this.onChanged,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  List<String> _subtasks = [];
  TextEditingController _editController = TextEditingController();
  TextEditingController _newTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subtasks = widget.taskList;
  }

  void _addSubtask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: _newTaskController,
          decoration: const InputDecoration(hintText: 'Enter new task'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _subtasks.add(_newTaskController.text);
                _newTaskController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editSubtask(int index) {
    _editController.text = _subtasks[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subtask'),
        content: TextField(
          controller: _editController,
          decoration: const InputDecoration(hintText: 'Enter new subtask'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _subtasks[index] = _editController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(value: widget.isSelected, onChanged: widget.onChanged),
                const SizedBox(width: 10),
                Text(
                  widget.taskName,
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 2),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subtasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_subtasks[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _editSubtask(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() => _subtasks.removeAt(index)),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: _addSubtask,
                  ),
                  Text("List item"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}