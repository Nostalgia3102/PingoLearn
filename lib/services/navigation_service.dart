import 'package:flutter/material.dart';
import 'package:pingo_learn_demo_app/ui/remote_config_example.dart';
import '../ui/home_page.dart';
import '../ui/signIn&LogIn/login_screen.dart';
import '../ui/signIn&LogIn/sign_up_page.dart';


class NavigationService{
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login_page" : (context) => const LoginScreen(),
    "/sign_up" : (context) => const SignUpScreen(),
    "/home_page" : (context) => const HomePage(),
    "/remote" : (context) => const RemoteConfigExample()
  };

  GlobalKey<NavigatorState>? get navigatorKey{
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService(){
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route){
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName){
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName){
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack(){
    _navigatorKey.currentState?.pop();
  }

}