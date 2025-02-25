import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/video_page.dart';

void main() {
  runApp(const DigiCollegeApp());
}

class DigiCollegeApp extends StatelessWidget {
  const DigiCollegeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DigiCollege',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/video': (context) => VideoPage(),
      },
    );
  }
}
