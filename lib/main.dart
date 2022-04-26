import 'package:bytebank_flutter2/http/webclient.dart';
import 'package:bytebank_flutter2/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(BytebankApp());
  findAll().then((transactions) => print('new transactions: ${transactions}'));
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: DS.primaryColor),
        primaryColor: DS.primaryColor,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.blueAccent[700]),
      ),
      home: Dashboard(),
    );
  }
}
