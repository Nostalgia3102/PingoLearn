import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigExample extends StatefulWidget {
  const RemoteConfigExample({super.key});

  @override
  _RemoteConfigExampleState createState() => _RemoteConfigExampleState();
}

class _RemoteConfigExampleState extends State<RemoteConfigExample> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String _welcomeMessage = 'Loading...';

  @override
  void initState() {
    super.initState();
    // _remoteConfig.setDefaults(const <String, dynamic>{
    //   'welcome_message': 'Welcome to my Flutter app!',
    // });
    _fetchRemoteConfig();
  }

  Future<void> _fetchRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await _remoteConfig.fetchAndActivate();
      setState(() {
        _welcomeMessage = _remoteConfig.getString('welcome_message');
      });
    } catch (e) {
      print('Failed to fetch remote config: $e');
      setState(() {
        _welcomeMessage = 'Welcome to my Flutter app!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Remote Config')),
      body: Center(
        child: Text(
          _welcomeMessage,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}