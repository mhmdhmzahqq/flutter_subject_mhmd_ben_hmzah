import 'package:file/dashborad_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FileProfileApp());
}

class FileProfileApp extends StatelessWidget {
  const FileProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Handling Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3F51B5),
        brightness: Brightness.light,
      ),
      home: const DashboardPage(),
    );
  }
}
