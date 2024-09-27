// summary_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  Future<Map<String, double>> calculateTotals() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    final snapshot = await firestore.collection('users')
        .doc(auth.currentUser?.uid)
        .collection('transactions').get();

    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in snapshot.docs) {
      final amount = transaction['amount'];
      final type = transaction['type'];

      if (type == 'Income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    }

    return {
      'income': totalIncome,
      'expense': totalExpense,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: FutureBuilder<Map<String, double>>(
        future: calculateTotals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final totals = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Income: ${totals['income']}'),
              Text('Total Expense: ${totals['expense']}'),
              Text('Net Balance: ${totals['income']! - totals['expense']!}'),
            ],
          );
        },
      ),
    );
  }
}
