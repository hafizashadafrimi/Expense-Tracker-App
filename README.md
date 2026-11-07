# Expense Tracker

Expense Tracker is a personal finance app for recording daily income and expenses. Totals and the current balance update as soon as a transaction is saved, edited, or deleted. Records stay on the device in a local SQLite database, so they are still there after the app is closed and opened again.

## Features

- Dashboard titled **Expense Tracker**
- Summary cards for **Total Income**, **Total Expense**, and **Current Balance**
- Recent transactions on the dashboard, plus a full transaction list
- Floating action button to add a transaction
- Form with title, amount, category, income or expense, and a date picker
- Validation before saving
- Transaction details with edit and delete
- Confirmation dialog before a transaction is deleted
- Income shown in green and expenses shown in rose

## Assignment checklist

| Requirement | Where it is handled |
| --- | --- |
| App name: Expense Tracker | Dashboard heading and app title |
| Total Income, Total Expense, Current Balance | Dashboard summary cards, calculated from saved transactions |
| Recent transactions | Dashboard list |
| Floating action button to add | Dashboard **Add** button |
| Title, amount, category, type, and date | Add and update form |
| Title cannot be empty | Form validation |
| Amount must be a positive number | Form validation |
| Category must be selected | Dropdown validation |
| Transaction type must be selected | Income / Expense choices |
| Date picker | Date field on the form |
| All transactions with `ListView.builder` | All transactions screen, and the recent list |
| Title, amount, category, date, and type on each row | Transaction tile |
| Different colors for income and expenses | Green for income, rose for expenses |
| Edit an existing transaction | Transaction details → Edit, then Save |
| Updated values stored locally | `TransactionRepository.update` writes through Sqflite |
| Delete with an `AlertDialog` | Transaction details → Delete |
| List and summaries refresh after delete | Repository notifies the dashboard and lists |
| Full details, plus Edit and Delete | Transaction details screen |
| Database `expense_tracker.db` | `DatabaseHelper` |
| Table `transactions` | `id`, `title`, `amount`, `category`, `type`, `date` |
| Data remains after restart | SQLite file on the device |

## Database

Database name: `expense_tracker.db`  
Table name: `transactions`

| Column | Type |
| --- | --- |
| id | INTEGER PRIMARY KEY AUTOINCREMENT |
| title | TEXT |
| amount | REAL |
| category | TEXT |
| type | TEXT |
| date | TEXT |

`type` is stored as `Income` or `Expense`. `date` is stored as an ISO-8601 string.

## Project structure

```text
lib/
  main.dart
  data/database_helper.dart
  data/transaction_repository.dart
  models/transaction_item.dart
  screens/dashboard_screen.dart
  screens/transaction_form_screen.dart
  screens/transaction_list_screen.dart
  screens/transaction_detail_screen.dart
  theme/app_theme.dart
  widgets/summary_card.dart
  widgets/transaction_tile.dart
```

## Run the app

Flutter 3.16 or newer is required.

```bash
flutter pub get
flutter run
```

On Windows and Linux the app uses `sqflite_common_ffi` so the same SQLite file works on the desktop. On Android and iOS it uses the platform Sqflite implementation.

```bash
flutter test
flutter analyze
```

## Categories

Food, Transport, Shopping, Bills, Salary, Freelance, Health, Entertainment, Education, and Other.
