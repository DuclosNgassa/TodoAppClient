import 'dart:convert';

import 'package:http/http.dart' as http;
import '../global.dart';
import 'package:query_params/query_params.dart';

class Task {
  int id;
  String name;
  bool isFinished;
  int todoID;

  Task({this.id, this.name, this.isFinished, this.todoID});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json["id"],
        name: json["name"],
        isFinished: json["isfinished"],
        todoID: json["todoid"]);

  }

  //clone a Task, or copy constructor
  factory Task.fromTask(Task anotherTask) {
    return Task(
        id: anotherTask.id,
        name: anotherTask.name,
        isFinished: anotherTask.isFinished,
        todoID: anotherTask.todoID);
  }
}

//Controller -> functions relating to Task
Future<List<Task>> fetchTasks(http.Client client, int todoId) async {
  final response = await client.get('$URL_TASKS_BY_TODOID$todoId');
  print('Task received1' + response.body);
  if(response.statusCode == 200){
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if(mapResponse["result"] == "Ok"){
      print('Task received');
      final tasks = mapResponse["data"].cast<Map<String, dynamic>>();
      final listOfTasks = await tasks.map<Task>((json) {
        return Task.fromJson(json);
      }).toList();
      return listOfTasks;
    }else{
      return [];
    }
  }else{
    throw Exception('Failed to load Task');
  }
}