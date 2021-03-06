// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bytebank_flutter2/screens/contacts_list.dart';
import 'package:flutter/material.dart';

import 'transactions_list.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('images/bytebank_logo.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.19,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FeatureItem(
                  'Transfer',
                  Icons.monetization_on,
                  onClick: () {
                    _showContactsList(context);
                  },
                ),
                _FeatureItem(
                  'Transaction feed',
                  Icons.description,
                  onClick: () => _showTransactionList(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showTransactionList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionsList(),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  const _FeatureItem(this.name, this.icon, {required this.onClick});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showContactsList(BuildContext context) {
  Navigator.of(context).push(
    (MaterialPageRoute(
      builder: (context) => ContactsList(),
    )),
  );
}
