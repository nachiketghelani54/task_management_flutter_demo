import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:task_demo/controller/home_controller.dart';
import 'package:task_demo/model/task_model.dart';
import 'package:task_demo/view/task_add_screen.dart';
import 'package:task_demo/view/widget/ui_widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const TaskAddScreen());
            },
            child: const Icon(Icons.add)),
        appBar: _buildAppBar(),
        body: _buildBodyWidget());
  }

  Obx _buildBodyWidget() {
    return Obx(() {
        if (_controller.isLoading.value) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: CircularProgressIndicator(),)],
          );
        } else {
          return _controller.taskList.isEmpty ?
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('No Task Found'),)
                ],
              ):
          _buildTaskListViewWidget();
        }
      });
  }

  ListView _buildTaskListViewWidget() {
    return ListView.builder(
              itemBuilder: (context, index) {
                return _buildSlidableWidget(index);
              },
              itemCount: _controller.taskList.length);
  }

  Slidable _buildSlidableWidget(int index) {
    return Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) {
                          _controller.deleteTaskData(_controller.taskList[index]);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  )
                  ,child:
                GestureDetector(
                onTap: (){
                  _controller.currentTaskModel=_controller.taskList[index];
                  Get.to(TaskAddScreen())?.then((value) => _controller.currentTaskModel=TaskModel(id: -1,status: "",description: "",dueDate: "",title: ""));
                },
                child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      child:
                          _buildTaskColumnWidget(index),
                    )
                ),
              ));
  }

  Column _buildTaskColumnWidget(int index) {
    return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(_controller.taskList[index].status.toUpperCase(),style: TextStyle(fontSize:13,color: colorStatus(status: _controller.taskList[index].status))),
                            ),
                            Divider(color: colorStatus(status: _controller.taskList[index].status)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(_controller.taskList[index].title,style: TextStyle(color: Colors.black,fontSize: 20),),
                              Text(_controller.taskList[index].description,style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                            ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(child:Text(_controller.taskList[index].dueDate,style: TextStyle(fontSize: 11),) ,),

                              ],
                            ),

                          ],



                    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        title: const Text('Show Task'),
        actions: [
          Obx(() =>
          DropdownButton<String>(
            value: _controller.currentFilter.value,

            items: _controller.filterList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(

                value: value,
                child:
                Text(
                  value,
                  style: TextStyle(fontSize: 14),
                )
              );
            }).toList(),
            onChanged: (String? newValue) {
                _controller.currentFilter.value = newValue!;
                _controller.filterTaskData(_controller.currentFilter.value);
            },
          ),)
        ],
      );
  }
}
