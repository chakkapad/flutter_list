// add_transaction_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}
  
class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late String type = 'Income';
  late double amount;
  late String note;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = double.parse(value);
              },
              decoration: const InputDecoration(hintText: 'Amount'),
            ),
            TextField(
              onChanged: (value) {
                note = value;
              },
              decoration: const InputDecoration(hintText: 'Note'),
            ),
            DropdownButton<String>(
              value: type,
              items: ['Income', 'Expense'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  type = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore.collection('users').doc(user.uid)
                      .collection('transactions').add({
                    'amount': amount,
                    'note': note,
                    'type': type,
                    'date': DateTime.now(),
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
