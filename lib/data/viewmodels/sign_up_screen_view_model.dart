import 'package:flutter/material.dart';

class SignUpScreenViewModel extends ChangeNotifier{
  final GlobalKey<FormState> signUpFormKey = GlobalKey();

  bool _registerPressed = false;
  bool get registerPressed => _registerPressed;
  set registerPressed(bool value){
    _registerPressed = value;
    notifyListeners();
  }


  String? _name;
  String? get name => _name;
  set name(String? value) {
    _name = value;
    notifyListeners();
  }

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

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  set phoneNumber(String? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  bool _eyeButton = false;
  bool get eyeButton => _eyeButton;
  set eyeButton(bool value){
    _eyeButton = value;
    notifyListeners();
  }

  void setRegisterPressed(SignUpScreenViewModel provider,bool value) {
    provider.registerPressed = value;
  }

  void toggleEyeButton(SignUpScreenViewModel provider,bool value) {
    provider.eyeButton = value;
  }

}