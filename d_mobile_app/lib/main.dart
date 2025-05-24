import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const DurillaApp());
}

class DurillaApp extends StatelessWidget {
  const DurillaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Durilla',
      home: HomeScreen(),
    );
  }
}
