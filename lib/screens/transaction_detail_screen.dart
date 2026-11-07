import 'package:flutter/material.dart';

import '../data/transaction_repository.dart';
import '../models/transaction_item.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'transaction_form_screen.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  static const routeName = '/transaction-detail';

  final int transactionId;

  Future<void> _edit(BuildContext context, TransactionItem item) {
    return Navigator.pushNamed(
      context,
      TransactionFormScreen.routeName,
      arguments: item,
    );
  }

  Future<void> _delete(BuildContext context, TransactionItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete transaction?'),
          content: Text(
            '${item.title} will be removed. Income, expenses, and balance will update.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.expense,
                foregroundColor: AppColors.cream,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await TransactionScope.of(context).delete(item.id!);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = TransactionScope.of(context).findById(transactionId);
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction details')),
        body: const AppBackground(
          child: Center(child: Text('This transaction is no longer available.')),
        ),
      );
    }

    final accent = item.isIncome ? AppColors.income : AppColors.expense;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Transaction details')),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: item.isIncome
                      ? const [Color(0xFF1E6B4A), AppColors.incomeDeep]
                      : const [Color(0xFF8A3144), AppColors.expenseDeep],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.type,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: AppColors.cream,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.isIncome ? '+' : '-'}${formatMoney(item.amount)}',
                    style: const TextStyle(
                      color: AppColors.cream,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Category',
              value: item.category,
              icon: iconForCategory(item.category),
            ),
            _DetailRow(
              label: 'Date',
              value: formatDate(item.date),
              icon: Icons.calendar_month_rounded,
            ),
            _DetailRow(
              label: 'Transaction type',
              value: item.type,
              icon: item.isIncome
                  ? Icons.south_west_rounded
                  : Icons.north_east_rounded,
            ),
            _DetailRow(
              label: 'Amount',
              value: formatMoney(item.amount),
              icon: Icons.payments_rounded,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _edit(context, item),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Edit'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              key: const Key('deleteButton'),
              onPressed: () => _delete(context, item),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.expense,
                side: const BorderSide(color: AppColors.expense),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
