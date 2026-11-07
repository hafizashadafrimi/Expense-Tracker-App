import 'package:flutter/material.dart';

import '../data/transaction_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_detail_screen.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  static const routeName = '/transactions';

  @override
  Widget build(BuildContext context) {
    final items = TransactionScope.of(context).items;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('All transactions')),
      body: AppBackground(
        child: items.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No transactions yet. Add one from the dashboard.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return TransactionTile(
                    item: item,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TransactionDetailScreen.routeName,
                        arguments: item.id,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
