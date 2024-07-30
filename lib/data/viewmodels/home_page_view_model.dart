import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier{
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value){
    _selectedIndex = value;
    notifyListeners();
  }

  int _numberOfListOfRestaurants = 0;
  int get numberOfListOfRestaurants => _numberOfListOfRestaurants;
  set numberOfListOfRestaurants(int value){
    _numberOfListOfRestaurants = value;
    notifyListeners();
  }
}