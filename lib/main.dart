import 'package:flutter/material.dart';
import 'package:pingo_learn_demo_app/services/navigation_service.dart';
import 'package:pingo_learn_demo_app/utils/constants/strings.dart';
import 'package:pingo_learn_demo_app/utils/utilities.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFireBase();
  await registerServices();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: StringsAsset.projectName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        initialRoute: authService.user!=null ? "/home_page" : "/login_page",
        navigatorKey: navigationService.navigatorKey,
        routes: NavigationService().routes,
      ),
    );
  }
}