import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:pingo_learn_demo_app/data/viewmodels/home_page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/viewmodels/login_screen_view_model.dart';
import '../data/viewmodels/sign_up_screen_view_model.dart';
import '../firebase_options.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';

///Instance Registrations
final GetIt getIt = GetIt.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


///Services instances
NavigationService navigationService = getIt.get<NavigationService>();
AuthService authService = getIt.get<AuthService>();
// DatabaseServices databaseServices = getIt.get<DatabaseServices>();

///ChangeNotifierProvider Registrations
final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => LoginScreenViewModel()),
  ChangeNotifierProvider(create: (context) => SignUpScreenViewModel()),
  ChangeNotifierProvider(create: (context) => HomePageViewModel())
];

///Firebase Setup
Future<void> setUpFireBase() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print("Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized");

  } catch (e) {
    print("Error during Firebase setup: $e");
  }
}

///Service Registrations
Future<void> registerServices() async {
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  // getIt.registerSingleton<DatabaseServices>(DatabaseServices());

  debugPrint("Services Registered");
}
