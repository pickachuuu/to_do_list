import 'package:hive_flutter/hive_flutter.dart';
class ToDoDatabase{
    List<dynamic> tileVal = [];
    final _myBox = Hive.box('mybox');

    void createInitialData() {
      tileVal = [
        ["Welcome to your list", false, [["Incomplete task", false]]],
         ["second list", false, [["Complete task", false]]]
      ];
    }

    void loadData() {
      final retrievedData = _myBox.get("TODOLIST");
      print("Retrieved data: $retrievedData"); // Add this line
      tileVal = retrievedData is List<dynamic> ? retrievedData : [];
      print("Retrieved tile: $tileVal");
    } 

    void updateData(){
      _myBox.put("TODOLIST", tileVal);
    }

  void updateInnerList(int index, List<dynamic> newSubtask) {
    // Access the inner list
    // print("Runtime type of inner list: ${.runtimeType}");
    // print("Runtime type of test list: ${newSubtask.runtimeType}");

    print("${tileVal[index][2]} and ${newSubtask}");

    // tileVal[index][2].add(newSubtask);
    _myBox.put("TODOLIST", tileVal);
  }

}