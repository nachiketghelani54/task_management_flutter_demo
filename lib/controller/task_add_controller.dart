import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:task_demo/model/task_model.dart';

import '../constant/string_constant.dart';

class TaskAddController extends GetxController{
  late Box<dynamic> box;


TaskAddController(){
  box = Hive.box(hiveBoxKey);
}

/// Method to Add task in Cache
addTaskData({required String title, required String description, required String dueDate}) async {
  box.add(TaskModel(id: DateTime.now().microsecondsSinceEpoch, title: title, description: description, dueDate: dueDate, status: inCompleted));
}

/// Method to Upadte Task in Cache
updateTaskData(TaskModel task){
  var id=task.id;
  List<dynamic> taskModel = box.keys.cast().toList();
  for(var keys in taskModel){
    var currentTask=box.get(keys);
    if(currentTask.id==id){
      box.delete(keys);
      box.add(TaskModel(id: DateTime.now().microsecondsSinceEpoch, title: task.title, description: task.description, dueDate: task.dueDate, status: completed));
    }
  }
}


}