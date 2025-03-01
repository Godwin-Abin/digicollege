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
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) {
          final String username =
              ModalRoute.of(context)!.settings.arguments as String;
          return DashboardPage(username: username);
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/video') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return VideoPage(videoUrl: args['videoUrl']);
            },
          );
        }
        return null;
      },
    );
  }
}
