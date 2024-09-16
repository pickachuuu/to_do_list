import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/data/database.dart';
import 'package:to_do_list/util/dialog_box.dart';
import 'package:to_do_list/util/list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  final _controller = TextEditingController();
  bool _isSelectingAll = false;

  // Selected date for date picker
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  // Function to pick a date
  void _pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (newDate != null) {
      setState(() {
        selectedDate = newDate; // Update the selected date
      });
    }
  }

  // Save new task
  void saveNewTask() {
    setState(() {
      db.tileVal.add([_controller.text, false, []]);
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  // Create a new task with a dialog
  void createTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // Handle checkbox selection
  void boxSelected(bool? value, int index) {
    setState(() {
      db.tileVal[index][1] = value!; // Update the task's selected state
    });
    db.updateData();
  }

  // Select or delete all tasks
  void _selectOrDeleteAll() {
    if (_isSelectingAll) {
      // If delete mode, confirm before deleting
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete All'),
          content:
              const Text('Are you sure you want to delete all selected tasks?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Restore state if user cancels
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  db.tileVal.removeWhere(
                      (task) => task[1] == true); // Delete only selected tasks
                });
                db.updateData();
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
else {
      // Select all tasks
      setState(() {
        for (var task in db.tileVal) {
          task[1] = true; // Mark all tasks as selected
        }
      });
      db.updateData();
    }

    // Toggle the button state
    setState(() {
      _isSelectingAll = !_isSelectingAll;
    });
  }

  // Edit a task
  void _editTask(int index) {
    final TextEditingController _editController = TextEditingController();
    _editController.text =
        db.tileVal[index][0]; // Pre-fill with current task name

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: _editController,
          decoration: const InputDecoration(hintText: 'Enter new task name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_editController.text.isNotEmpty) {
                setState(() {
                  db.tileVal[index][0] =
                      _editController.text; // Update task name
                });
                db.updateData();
              }
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
    // Format the selected date
    final String formattedDate =
        DateFormat('EEEE, MMMM d').format(selectedDate);
return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff6a11cb),
                Color(0xff2575fc),
              ],
            ),
          ),
        ),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'To Do\'s',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: _pickDate,
                child: Text(
                  formattedDate,
                  style: GoogleFonts.lato(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Select All/Delete All button on the bottom left
          Padding(
            padding: const EdgeInsets.only(left: 32.0, bottom: 30),
            child: FloatingActionButton(
              backgroundColor: _isSelectingAll ? Colors.red : Colors.deepPurple,
              onPressed: _selectOrDeleteAll,
              child: Icon(
                _isSelectingAll ? Icons.delete : Icons.select_all,
                color: Colors.white,
              ),
            ),
          ),
          // Create Task button on the bottom right
          Padding(
            padding: const EdgeInsets.only(right: 32.0, bottom: 30),
            child: FloatingActionButton(
              onPressed: createTask,
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Avoid overlap with FABs
        child: ListView.builder(
          itemCount: db.tileVal.length,
          itemBuilder: (context, index) {
            return TaskTile(
              taskName: db.tileVal[index][0],
              isSelected: db.tileVal[index][1],
              taskList: db.tileVal[index][2],
              onChanged: (value) => boxSelected(value, index),
              index: index, // Ensure index is passed
              onInsert: (index, newSubtask) => db.insertInnerList(index, newSubtask),
              updateData: () => db.updateData(),
            );
          },
        ),
      ),
    );
  }
}




// taskName: db.tileVal[index][0],
//             isSelected: db.tileVal[index][1],
//             taskList: db.tileVal[index][2],
//             onChanged: (value) => boxSelected(value, index),
//             index: index,
//             onInsert: (index, newSubtask) => db.insertInnerList(index, newSubtask),
//             updateData: () => db.updateData(),