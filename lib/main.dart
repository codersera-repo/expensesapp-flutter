import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterApp', 
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.black,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold, 
            )
          )
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransactions = [
    //  Transaction(id: '1', title: 'New Shoes', amount: 2.00, date: DateTime.now()),
    //  Transaction(id: '2', title: 'Watch', amount: 4.00, date: DateTime.now()),
  ];

  void _addNewTransaction(String title, double amount, DateTime chosenDate){
    print(chosenDate);
    final newTx = Transaction(title: title, amount: amount, id: DateTime.now().toString(), date: chosenDate);

    setState(() {
      this._userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (_){
      return NewTransaction(this._addNewTransaction);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      this._userTransactions.removeWhere((tx) => id == tx.id);
    });
  }

  List<Transaction> get recentTransactions{
    return _userTransactions.where((tx){
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter App',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () => _startAddNewTransaction(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(recentTransactions),
            TransactionList(this._userTransactions, this._deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
    );
  }
}
