import 'package:flutter/material.dart';
import 'package:teste/app/exceptions/NoRegisteredUsersException.dart';
import 'package:teste/app/exceptions/PasswordNotFoundException.dart';
import 'package:teste/app/exceptions/EmailNotFoundException.dart';
import 'package:teste/app/models/user.dart';
import 'package:teste/data/dummy_users.dart';

class Users with ChangeNotifier {
  final Map<String, User> _items = {...DUMMY_USERS};

  List<User> get all {
    return [..._items.values];
  }

  User? getUserByEmail(String email) {
    for (var user in _items.values) {
      if (user.email == email) {
        return user;
      }
    }

    return null;
  }

  bool isUserRegistered(String email, String password) {
    User? user = getUserByEmail(email);

    if (user == null) {
      throw EmailNotFoundException();
    }

    if (user.password != password) {
      throw PasswordNotFoundException();
    }

    return true;
  }

  void isEmpty() {
    if (count <= 0) {
      throw NoRegisteredUsersException();
    }
  }

  int get count {
    return _items.length;
  }

  User byIndex(int index) {
    return _items.values.elementAt(index);
  }

  User? byId(String id) {
    return _items[id];
  }

  void put(User user) {
    if (user == null) {
      return;
    }

    //update
    if (user.id != null &&
        user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      _items.update(
          user.id,
          (_) => User(
              id: user.id,
              name: user.name,
              email: user.email,
              password: user.password,
              passes: user.passes,
              avatarUrl: user.avatarUrl));
    }

    //create
    _items.putIfAbsent(
        user.id,
        () => User(
            id: user.id,
            name: user.name,
            email: user.email,
            password: user.password,
            passes: user.passes,
            avatarUrl: user.avatarUrl));

    notifyListeners();
  }

  void usePass(User? user) {
    int newPasses = user!.passes;
    if (user.passes > 0) {
      newPasses -= 1;
      _items.update(
          user.id,
          (_) => User(
              id: user.id,
              name: user.name,
              email: user.email,
              password: user.password,
              passes: newPasses,
              avatarUrl: user.avatarUrl));
      notifyListeners();
    }
  }

  void getPass(User? user) {
    _items.update(
        user!.id,
        (_) => User(
            id: user.id,
            name: user.name,
            email: user.email,
            password: user.password,
            passes: 40,
            avatarUrl: user.avatarUrl));
    notifyListeners();
  }

  //delete
  void remove(User user) {
    if (user != null && user.id != null) {
      _items.remove(user.id);
      notifyListeners();
    }
  }
}
