import 'package:hive_flutter/hive_flutter.dart';
class ToDoDatabase{
    List<dynamic> tileVal = [];
    final _myBox = Hive.box('mybox');

    void createInitialData() {
      tileVal = [
        ["Welcome to your list", false, [["Incomplete task", false], ["Complete task", true]]],
      ];
    }

    void loadData() {
      final retrievedData = _myBox.get("TODOLIST");
      tileVal = retrievedData;
    } 

    void updateData(){
      _myBox.put("TODOLIST", tileVal);
    }

    void insertInnerList(int index, List<dynamic> newSubtask) {
      _myBox.put("TODOLIST", tileVal);
    }
}