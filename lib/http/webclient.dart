import 'dart:convert';
import 'dart:io';

import 'package:bytebank_flutter2/models/contact.dart';
import 'package:bytebank_flutter2/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

final Client client =
    InterceptedClient.build(interceptors: [LoggingInterceptor()]);

const String baseUrl = 'http://192.168.63.125:8080/transactions';

Future<List<Transaction>> findAll() async {
  final Response response =
      await client.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 5));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = [];

  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Map<String, dynamic> contactJson = transactionJson['contact'];
    final Transaction transaction = Transaction(
      transactionJson['value'],
      Contact(
        contactJson['name'],
        contactJson['accountNumber'],
        0,
      ),
    );
    transactions.add(transaction);
  }
  return transactions;
}

Future<Transaction> save(Transaction transaction) async {
  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };
  final String transactionJson = jsonEncode(transactionMap);
  final Response response = await client.post(Uri.parse(baseUrl),
      headers: {
        'Content-type': 'application/json',
        'password': '1000',
      },
      body: transactionJson);
  Map<String, dynamic> json = jsonDecode(response.body);
  final Map<String, dynamic> contactJson = json['contact'];
  return Transaction(
    json['value'],
    Contact(
      contactJson['name'],
      contactJson['accountNumber'],
      0,
    ),
  );
}
