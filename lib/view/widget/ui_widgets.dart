import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_demo/constant/string_constant.dart';

colorStatus({String status = all}){
  if(status == inCompleted){
    return Colors.red;
  }else if(status == completed){
    return Colors.green;
  }else{
    return Colors.blue;
  }
}