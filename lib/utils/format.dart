import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatMoney(double amount) {
  final negative = amount < 0;
  final fixed = amount.abs().toStringAsFixed(2);
  final pieces = fixed.split('.');
  final whole = pieces[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
  return '${negative ? '-' : ''}৳$whole.${pieces[1]}';
}

String formatDate(DateTime date) {
  return DateFormat('d MMM yyyy').format(date);
}

IconData iconForCategory(String category) {
  switch (category) {
    case 'Food':
      return Icons.restaurant_rounded;
    case 'Transport':
      return Icons.directions_bus_rounded;
    case 'Shopping':
      return Icons.shopping_bag_rounded;
    case 'Bills':
      return Icons.receipt_long_rounded;
    case 'Salary':
      return Icons.payments_rounded;
    case 'Freelance':
      return Icons.work_rounded;
    case 'Health':
      return Icons.favorite_rounded;
    case 'Entertainment':
      return Icons.movie_rounded;
    case 'Education':
      return Icons.school_rounded;
    default:
      return Icons.category_rounded;
  }
}
