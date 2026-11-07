import 'package:flutter/material.dart';

import '../data/transaction_repository.dart';
import '../models/transaction_item.dart';
import '../theme/app_theme.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_detail_screen.dart';
import 'transaction_form_screen.dart';
import 'transaction_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  Future<void> _openForm(BuildContext context) {
    return Navigator.pushNamed(context, TransactionFormScreen.routeName);
  }

  void _openDetails(BuildContext context, TransactionItem item) {
    Navigator.pushNamed(
      context,
      TransactionDetailScreen.routeName,
      arguments: item.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = TransactionScope.of(context);
    final recent = repository.recent;
    final wide = MediaQuery.sizeOf(context).width >= 860;

    final balanceCard = SummaryCard(
      label: 'Current Balance',
      amount: repository.balance,
      icon: Icons.account_balance_wallet_rounded,
      note: repository.balance < 0 ? 'Overspent' : 'Available',
      large: true,
      colors: const [Color(0xFF8A6A2F), Color(0xFF2A2416)],
    );
    final incomeCard = SummaryCard(
      label: 'Total Income',
      amount: repository.totalIncome,
      icon: Icons.south_west_rounded,
      colors: const [Color(0xFF1E6B4A), AppColors.incomeDeep],
    );
    final expenseCard = SummaryCard(
      label: 'Total Expense',
      amount: repository.totalExpense,
      icon: Icons.north_east_rounded,
      colors: const [Color(0xFF8A3144), AppColors.expenseDeep],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting().toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expense Tracker',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Income, expenses, and your balance, kept on this device.',
                      ),
                      const SizedBox(height: 22),
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: balanceCard),
                            const SizedBox(width: 14),
                            Expanded(flex: 4, child: incomeCard),
                            const SizedBox(width: 14),
                            Expanded(flex: 4, child: expenseCard),
                          ],
                        )
                      else ...[
                        balanceCard,
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: incomeCard),
                            const SizedBox(width: 12),
                            Expanded(child: expenseCard),
                          ],
                        ),
                      ],
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Recent transactions',
                              style: TextStyle(
                                color: AppColors.cream,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                TransactionListScreen.routeName,
                              );
                            },
                            child: const Text('See all'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              if (recent.isEmpty)
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverToBoxAdapter(child: _EmptyTransactions()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverToBoxAdapter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recent.length,
                      itemBuilder: (context, index) {
                        final item = recent[index];
                        return TransactionTile(
                          item: item,
                          onTap: () => _openDetails(context, item),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.line),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.auto_graph_rounded,
            color: AppColors.gold,
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: AppColors.cream,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tap Add to record income or an expense.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
