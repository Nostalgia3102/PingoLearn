import 'package:flutter/material.dart';

class LoginScreenViewModel extends ChangeNotifier{

  final GlobalKey<FormState> loginFormKey = GlobalKey();

  String? _email;
  String? get email => _email;
  set email(String? value) {
    _email = value;
    notifyListeners();
  }

  String? _password;
  String? get password => _password;
  set password(String? value) {
    _password = value;
    notifyListeners();
  }

  bool _eyeButton = false;
  bool get eyeButton => _eyeButton;
  set eyeButton(bool value){
    _eyeButton = value;
    notifyListeners();
  }
}