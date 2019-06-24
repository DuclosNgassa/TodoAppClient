import 'dart:convert';

import 'package:http/http.dart' as http;
import '../global.dart';

class Todo {
  int id;
  String name;
  String dueDate;
  String description;

  Todo({this.id, this.name, this.dueDate, this.description});

  // this is a static method
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json["id"],
        name: json["name"],
        dueDate: json["duedate"],
        description: json["description"]);
  }
}

/**
 * Fetch Todo from Restful API
 */
Future<List<Todo>> fetchTodos(http.Client client) async {
  final response = await client.get(URL_TODOS);
  if (response.statusCode == 200) {
    //print('Todo received1' + response.body);
    Map<String, dynamic> mapResponse = json.decode(response.body);
    //print('Todo dynamic ' + mapResponse["result"]);
    if (mapResponse["result"] == "Ok") {
      print('Todo received');
      final todos = mapResponse["data"].cast<Map<String, dynamic>>();
      final listOfTodos = await todos.map<Todo>((json) {
        return Todo.fromJson(json);
      }).toList();
      return listOfTodos;
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load Todo from the Internet');
  }
}
