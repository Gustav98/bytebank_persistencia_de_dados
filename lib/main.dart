import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.green[900]),
          primaryColor: Colors.green[900]),
      home: Dashboard(),
    );
  }
}
