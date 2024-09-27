// transaction_list_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class TransactionListScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('transactions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!.docs;
          List<ListTile> transactionWidgets = [];
          for (var transaction in transactions) {
            final amount = transaction['amount'];
            final note = transaction['note'];
            final type = transaction['type'];
            final date = transaction['date'].toDate();

            final transactionWidget = ListTile(
              title: Text('$type: $amount'),
              subtitle: Text('$note \n$date'),
            );
            transactionWidgets.add(transactionWidget);
          }

          return ListView(children: transactionWidgets);
        },
      ),
    );
  }
}
