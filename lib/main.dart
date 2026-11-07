import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'data/transaction_repository.dart';
import 'models/transaction_item.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/transaction_form_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final repository = TransactionRepository();
  await repository.load();
  runApp(ExpenseTrackerApp(repository: repository));
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key, required this.repository});

  final TransactionRepository repository;

  @override
  Widget build(BuildContext context) {
    return TransactionScope(
      repository: repository,
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const DashboardScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case TransactionFormScreen.routeName:
              final existing = settings.arguments is TransactionItem
                  ? settings.arguments as TransactionItem
                  : null;
              return _fadeRoute(TransactionFormScreen(existing: existing));
            case TransactionListScreen.routeName:
              return _fadeRoute(const TransactionListScreen());
            case TransactionDetailScreen.routeName:
              final id = settings.arguments as int;
              return _fadeRoute(TransactionDetailScreen(transactionId: id));
            default:
              return _fadeRoute(const DashboardScreen());
          }
        },
      ),
    );
  }
}

PageRoute<void> _fadeRoute(Widget child) {
  return PageRouteBuilder<void>(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}
