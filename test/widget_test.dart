import 'package:expense_tracker/data/database_helper.dart';
import 'package:expense_tracker/data/transaction_repository.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  setUp(() async {
    await DatabaseHelper.instance.close();
    final directory = await getDatabasesPath();
    await deleteDatabase(join(directory, DatabaseHelper.databaseName));
  });

  testWidgets('dashboard shows the name and summary cards', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Total Income'), findsOneWidget);
    expect(find.text('Total Expense'), findsOneWidget);
    expect(find.text('Current Balance'), findsOneWidget);
    expect(find.text('৳0.00'), findsWidgets);
  });

  testWidgets('empty save shows validation messages', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await _settle(tester);

    expect(find.text('Add Transaction'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));
    await _settle(tester);

    expect(find.text('Title cannot be empty.'), findsOneWidget);
    expect(
      find.text('Amount must be a valid positive number.'),
      findsOneWidget,
    );
    expect(find.text('Category must be selected.'), findsOneWidget);
    expect(find.text('Transaction type must be selected.'), findsOneWidget);
  });

  testWidgets('add, view, edit, and delete a transaction', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await _settle(tester);

    await tester.enterText(find.byKey(const Key('titleField')), 'Lunch');
    await tester.enterText(find.byKey(const Key('amountField')), '250');
    await tester.tap(find.byKey(const Key('categoryField')));
    await _settle(tester);
    await tester.tap(find.text('Food').last);
    await _settle(tester);
    await tester.tap(find.byKey(const Key('typeExpense')));
    await _settle(tester);
    await tester.ensureVisible(find.byKey(const Key('saveButton')));
    await tester.tap(find.byKey(const Key('saveButton')));
    await _settle(tester);

    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('-৳250.00'), findsWidgets);
    expect(find.text('৳250.00'), findsWidgets);

    await tester.tap(find.text('Lunch'));
    await _settle(tester);
    expect(find.text('Transaction details'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
    expect(find.text('Expense'), findsWidgets);

    await tester.tap(find.text('Edit'));
    await _settle(tester);
    expect(find.text('Update Transaction'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('titleField')), 'Dinner');
    await tester.ensureVisible(find.byKey(const Key('saveButton')));
    await tester.tap(find.byKey(const Key('saveButton')));
    await _settle(tester);

    expect(find.text('Dinner'), findsWidgets);

    await tester.tap(find.byKey(const Key('deleteButton')));
    await _settle(tester);
    expect(find.text('Delete transaction?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await _settle(tester);

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('৳0.00'), findsWidgets);
  });
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 30));
  });
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1200, 2200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfiNoIsolate;

  final repository = TransactionRepository();
  await tester.runAsync(repository.load);
  await tester.pumpWidget(ExpenseTrackerApp(repository: repository));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}
