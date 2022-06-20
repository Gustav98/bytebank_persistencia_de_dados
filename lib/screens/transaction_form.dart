import 'dart:async';

import 'package:bytebank_flutter2/components/progress.dart';
import 'package:bytebank_flutter2/components/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../components/transaction_auth_dialog.dart';
import '../http/webclients/transaction_webclient.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String transactionId = Uuid().v4();
  bool _sending = false;
  @override
  Widget build(BuildContext context) {
    print('transaction form id $transactionId');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending...',
                  ),
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId, value!, widget.contact);
                      showDialog(
                        context: _scaffoldKey.currentContext!,
                        builder: (contextDialog) {
                          var transactionAuthDialog = TransactionAuthDialog(
                            onConfirm: (String password) {
                              _save(
                                  transactionCreated, password, contextDialog);
                            },
                          );
                          return transactionAuthDialog;
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext contextDialog,
  ) async {
    setState(() {
      _sending = true;
    });
    Transaction transaction =
        await _send(transactionCreated, password, context);

    _showSuccessfulMessage(transaction, context);
  }

  Future<void> _showSuccessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Successful transaction.');
          });
      Navigator.of(context).pop();
    }
  }

  Future _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    try {
      final Transaction transaction =
          await _webClient.save(transactionCreated, password);
      _showSuccessfulMessage(transaction, context);
    } on TimeoutException catch (e) {
      _showFailureMessage(context, message: e.message.toString());
    } on HttpException catch (e) {
      _showFailureMessage(context, message: e.message.toString());
    } on Exception catch (e) {
      _showFailureMessage(context);
    } finally {
      setState(() {
        _sending = false;
      });
    }
    // final Transaction transaction =
    //     await _webClient.save(transactionCreated, password).catchError((e) {
    //   _showFailureMessage(context, message: e.message);
    // }, test: (e) => e is HttpException).catchError((e) {
    //   _showFailureMessage(context,
    //       message: 'timeout submitting the transaction');
    // }, test: (e) => e is TimeoutException).catchError((e) {
    //   _showFailureMessage(context);
    // });
    // return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknow error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}
