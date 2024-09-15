import 'package:hive_flutter/hive_flutter.dart';
class ToDoDatabase{
    List tileVal = [];
    final _myBox = Hive.box('mybox');

    void createInitialData() {
      tileVal = [
        ["Welcome to your list", false, <String>[]],
        ["List your items", false, <String>["Your task"]]
      ];
    }

    void loadData(){
      tileVal = _myBox.get("TODOLIST");
    }

    void updateData(){
      _myBox.put("TODOLIST", tileVal);
    }


    void updateSubtask(String taskName, String newSubtask, {int index = -1}) {
    int taskIndex = tileVal.indexWhere((element) => element[0] == taskName);

    if (taskIndex != -1) {
      if (index != null) {
        tileVal[taskIndex][2][index] = newSubtask;
      } else {
        tileVal[taskIndex][2].add(newSubtask);
      }

      updateData();
    } else {
      print('Task not found: $taskName'); // Handle the case where the task doesn't exist
    }
  }
}