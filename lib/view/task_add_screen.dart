import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_demo/controller/home_controller.dart';
import 'package:task_demo/controller/task_add_controller.dart';
import 'package:get/get.dart';

import '../model/task_model.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({Key? key}) : super(key: key);

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final TaskAddController _controller = Get.put(TaskAddController());
  final HomeController _homeController = Get.put(HomeController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  DateTime selectedRequestedDate = DateTime.now();

  /// Method to Select Date From Picker
  Future<void> _selectScheduledDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,

        initialDate: selectedRequestedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedRequestedDate) {
      setState(() {
        selectedRequestedDate = picked;
        _dueDateController.text =
            DateFormat("d MMM yyyy").format(selectedRequestedDate);
      });
    } else {
      _dueDateController.text = "";
    }
  }
  @override
  void initState() {
    super.initState();
    if(_homeController.currentTaskModel.id!=-1){
      _titleController.text=_homeController.currentTaskModel.title;
      _descriptionController.text=_homeController.currentTaskModel.description;
      _dueDateController.text=_homeController.currentTaskModel.dueDate;
    }
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Form(
        key: _formKey,
        child:
      Column(
        children: [
          _textFormField(controller: _titleController, hintText: 'Title'),
          _textFormField(
              controller: _descriptionController, hintText: 'Description'),
          _textFormField(
              controller: _dueDateController,
              hintText: 'Due Date',
              readOnly: true,
              onTap: () {
                _selectScheduledDate(context);
              }),
          if(_homeController.currentTaskModel.id!=-1)
          _buildUpdateButtonWidget(),
          if(_homeController.currentTaskModel.id==-1)
            _buildSubmitButtonWidget()


        ],
      ),)
    );
  }

  ElevatedButton _buildSubmitButtonWidget() {
    return ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _controller.addTaskData(
                    title: _titleController.text,
                    description:_descriptionController.text,
                    dueDate:_dueDateController.text,);
                  Get.back(result: true);
                  _homeController.getTaskListData();
                }

              },
              child: const Text('Submit'));
  }

  ElevatedButton _buildUpdateButtonWidget() {
    return ElevatedButton(
            onPressed: () async {
              _homeController.currentTaskModel.title=_titleController.text;
              _homeController.currentTaskModel.description=_descriptionController.text;
              _homeController.currentTaskModel.dueDate=_dueDateController.text;
              await _controller.updateTaskData(_homeController.currentTaskModel);
              Get.back(result: true);
              _homeController.getAllTaskListData();
              _homeController.currentTaskModel=TaskModel(id: -1,status: "",description: "",dueDate: "",title: "");
            },
            child: const Text('Update'));
  }

  Widget _textFormField(
      {required TextEditingController controller,
      required String hintText,
      GestureTapCallback? onTap,
      bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onTap: onTap ?? () {},
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
