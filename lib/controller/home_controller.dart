import 'package:get/get.dart';
import 'package:task_demo/constant/string_constant.dart';
import 'package:task_demo/model/task_model.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController{
  RxBool isLoading = false.obs;
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  RxString currentFilter="All".obs;
  List<String> filterList=[all,inCompleted,completed];
  TaskModel currentTaskModel=TaskModel(id: -1,status: "",description: "",dueDate: "",title: "");

  late Box<dynamic> box;

  HomeController(){
    box = Hive.box(hiveBoxKey);
    getAllTaskListData();
  }

  /// Method to Update Task List
  getAllTaskListData(){
    try{
      isLoading.value = true;
      taskList.clear();
      List<dynamic> taskModel = box.values.cast().toList();
      for(TaskModel task in taskModel){
        taskList.add(task);
      }
    }finally{
      isLoading.value = false;
    }
  }

  /// Method to Delete a Task in Cache
  deleteTaskData(TaskModel task){
    isLoading.value=true;
    var id=task.id;
    List<dynamic> taskModel = box.keys.cast().toList();
    for(var keys in taskModel){
      var currenttask=box.get(keys);
      if(currenttask.id==id){
        box.delete(keys);
      }
    }
    isLoading.value=false;
    getAllTaskListData();
  }

  /// Method to Filter a Task
  filterTaskData(String filter){
    switch(filter){
      case all:
        getAllTaskListData();
        break;
      case inCompleted:
        getIncompletedTask();
        break;
      case completed:
        getCompletedTask();
        break;
    }
  }

  /// Method to Get Incomplete Task
  getIncompletedTask(){
    try{
      isLoading.value = true;
      taskList.clear();
      List<dynamic> taskModel = box.values.cast().toList();
      for(TaskModel task in taskModel){
        if(task.status==inCompleted){
        taskList.add(task);
        }
      }
    }finally{
      isLoading.value = false;
    }
  }

  /// Method to Get Completed Task
  getCompletedTask(){
    try{
      isLoading.value = true;
      taskList.clear();
      List<dynamic> taskModel = box.values.cast().toList();
      for(TaskModel task in taskModel){
        if(task.status==completed){
          taskList.add(task);
        }
      }
    }finally{
      isLoading.value = false;
    }
  }

  /// Method to Add Recently Added task and to Redraw UI
  getTaskListData(){
    try{
      isLoading.value = true;
      TaskModel taskModelList = box.values.cast().toList().last;
      taskList.add(taskModelList);
    }finally{
      isLoading.value = false;
    }
  }
}