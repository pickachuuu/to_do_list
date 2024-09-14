// hobby_list.dart
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // List of available hobbies
  List<Map> availableTask = [

  ];

  void addNewHobby(String taskName) {
    setState(() {
      availableTask.add({"name": taskName, "isChecked": false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                offset: Offset(0, 4),
                blurRadius: 2,
                spreadRadius: 1,
          )
        ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              "Note Title Here",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            
            
            
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
        
            // The checkboxes
            Column(
              children: availableTask.map((hobby) {
                return Row( // Change CheckboxListTile to Row
                  children: [
                    Checkbox( // Use Checkbox instead of CheckboxListTile
                      value: hobby["isChecked"],
                      onChanged: (bool? newValue) {
                        setState(() {
                          hobby["isChecked"] = newValue;
                        });
                      },
                    ),
                    const SizedBox(width: 5), // Add spacing between checkbox and text
                    Text(hobby["name"]),
                  ],
                );
              }).toList(),
            ),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Prompt user for new hobby name and add it
                        final TextEditingController taskNameController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Add New Task"),
                            content: TextField(
                              controller: taskNameController,
                              decoration: const InputDecoration(
                                hintText: "Enter task name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  addNewHobby(taskNameController.text);
                                  Navigator.pop(context);
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        );
                      },
                ),
                const SizedBox(width: 1),
                const Text("add list"),
              ],
            ),

            // Display the selected hobbies
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Wrap(
              children: availableTask.map((hobby) {
                if (hobby["isChecked"] == true) {
                  return Card(
                    elevation: 3,
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(hobby["name"],
                      ),
                    ),
                  );
                }
                return Container();
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
