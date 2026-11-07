import 'package:flutter/widgets.dart';

import '../models/transaction_item.dart';
import 'database_helper.dart';

class TransactionRepository extends ChangeNotifier {
  TransactionRepository({DatabaseHelper? database})
    : _database = database ?? DatabaseHelper.instance;

  final DatabaseHelper _database;
  List<TransactionItem> _items = [];

  List<TransactionItem> get items => List.unmodifiable(_items);

  List<TransactionItem> get recent => _items.take(5).toList();

  TransactionItem? findById(int id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  double get totalIncome {
    return _items
        .where((item) => item.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return _items
        .where((item) => !item.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
  }

  double get balance => totalIncome - totalExpense;

  Future<void> load() async {
    _items = await _database.getAll();
    notifyListeners();
  }

  Future<void> add(TransactionItem item) async {
    await _database.insert(item);
    await load();
  }

  Future<void> update(TransactionItem item) async {
    await _database.update(item);
    await load();
  }

  Future<void> delete(int id) async {
    await _database.delete(id);
    await load();
  }
}

class TransactionScope extends InheritedNotifier<TransactionRepository> {
  const TransactionScope({
    super.key,
    required TransactionRepository repository,
    required super.child,
  }) : super(notifier: repository);

  static TransactionRepository of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<TransactionScope>();
    assert(scope != null, 'TransactionScope was not found.');
    return scope!.notifier!;
  }
}
