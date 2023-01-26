import 'package:flutter/material.dart';
//
import 'package:dous/models/user.dart';
import 'package:dous/database/database.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  late bool _userExists;
  bool _busyCreatingUser = true;

  User get currentUser => _currentUser;
  bool get userExists => _userExists;
  bool get busyCreatingUser => _busyCreatingUser;

  Future<String> createUser(User user) async {
    String result = 'UserCreated';
    DataBase db = DataBase.instance;

    _busyCreatingUser = true;
    notifyListeners();

    try {
      _currentUser = await db.createUser(user);
      await Future.delayed(const Duration(seconds: 3));
      _busyCreatingUser = false;
      notifyListeners();
    } catch (error) {
      result = error.toString();
      print(error);
    }
    return result;
  }

  Future<String> checkIfUserExists(String username) async {
    String result = 'UserExists';
    try {
      _currentUser = await DataBase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      result = e.toString();
      print(e);
    }
    return result;
  }
}
