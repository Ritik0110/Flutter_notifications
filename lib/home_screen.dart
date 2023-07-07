import 'package:flutter/material.dart';
import 'package:notification/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices services = NotificationServices();
  @override
  void initState() {
    services.requestNotificationPermission();
    services.firebaseInit();
    services.getToken().then((value){
      print("Device token");
      print(value);
    });
    services.isTokenRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
    );
  }
}
