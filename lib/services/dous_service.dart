import 'package:flutter/material.dart';
//
import 'package:dous/database/database.dart';
import 'package:dous/models/dous_task.dart';

class DousService with ChangeNotifier {
  List<DoUsTask> _todos = [];

  List<DoUsTask> get todos => _todos;

  late bool isFetchingData;

  // Create A new task
  Future<String> createDous(DoUsTask todo) async {
    try {
      await DataBase.instance.createDousTask(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getDousTasks(todo.userName);
    return result;
  }

  Future<String> getDousTasks(String username) async {
    isFetchingData = true;
    notifyListeners();
    try {
      _todos = await DataBase.instance.getDousTasks(username);
      // await Future.delayed(Duration(seconds: 2));
      isFetchingData = false;
      notifyListeners();
    } catch (e) {
      print('Error Fetching Data getDousTasks');
      return e.toString();
    }
    return 'OK';
  }

  Future<String> updateDoUs(DoUsTask task) async {
    try {
      await DataBase.instance.updateDousTask(task);
    } catch (error) {
      print(error);
    }
    String result = await getDousTasks(task.userName);
    return result;
  }

  Future<String> deleteDoUs(DoUsTask task) async {
    try {
      await DataBase.instance.deleteDousTask(task);
    } catch (error) {
      print(error);
    }
    String result = await getDousTasks(task.userName);
    return result;
  }

  Future<String> toggleIsComplete(DoUsTask todo) async {
    try {
      await DataBase.instance.toggleDousIsDone(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getDousTasks(todo.userName);
    return result;
  }

  Future<String> toggleIsImportant(DoUsTask todo) async {
    try {
      await DataBase.instance.toggleDousIsImportant(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getDousTasks(todo.userName);
    return result;
  }
}
