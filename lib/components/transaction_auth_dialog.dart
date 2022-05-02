import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Authenticate'),
      content: const TextField(
        obscureText: true,
        maxLength: 4,
        decoration: InputDecoration(border: OutlineInputBorder()),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 64, letterSpacing: 32),
      ),
      actions: [
        TextButton(
          onPressed: () {
            print('CANCEL');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            print('CONFIRM');
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
