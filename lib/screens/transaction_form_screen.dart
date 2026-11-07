import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/transaction_repository.dart';
import '../models/transaction_item.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key, this.existing});

  static const routeName = '/transaction-form';

  final TransactionItem? existing;

  bool get isEditing => existing != null;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  String? _category;
  String? _type;
  late DateTime _date;
  String? _typeError;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _amountController = TextEditingController(
      text: existing == null ? '' : _plainAmount(existing.amount),
    );
    _category = existing?.category;
    _type = existing?.type;
    _date = existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _plainAmount(double amount) {
    final text = amount.toStringAsFixed(2);
    return text.endsWith('.00') ? amount.toStringAsFixed(0) : text;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    final typeSelected = _type != null;
    setState(() {
      _typeError = typeSelected
          ? null
          : 'Transaction type must be selected.';
    });
    if (!formValid || !typeSelected) {
      return;
    }

    final amount = double.parse(_amountController.text.trim());
    final item = TransactionItem(
      id: widget.existing?.id,
      title: _titleController.text.trim(),
      amount: amount,
      category: _category!,
      type: _type!,
      date: _date,
    );
    final repository = TransactionScope.of(context);
    if (widget.isEditing) {
      await repository.update(item);
    } else {
      await repository.add(item);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Update Transaction' : 'Add Transaction',
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                const _SectionLabel('Title'),
                TextFormField(
                  key: const Key('titleField'),
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: AppColors.cream),
                  decoration: const InputDecoration(
                    hintText: 'Salary, groceries, rent...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title cannot be empty.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const _SectionLabel('Amount'),
                TextFormField(
                  key: const Key('amountField'),
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: const TextStyle(color: AppColors.cream),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    prefixText: '৳ ',
                    prefixStyle: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse((value ?? '').trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Amount must be a valid positive number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const _SectionLabel('Category'),
                DropdownButtonFormField<String>(
                  key: const Key('categoryField'),
                  initialValue: _category,
                  dropdownColor: AppColors.cardSoft,
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Select a category',
                  ),
                  items: [
                    for (final category in transactionCategories)
                      DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Category must be selected.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const _SectionLabel('Transaction type'),
                Row(
                  children: [
                    Expanded(
                      child: _TypeChoice(
                        label: TransactionItem.income,
                        icon: Icons.south_west_rounded,
                        selected: _type == TransactionItem.income,
                        color: AppColors.income,
                        onTap: () => setState(() {
                          _type = TransactionItem.income;
                          _typeError = null;
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeChoice(
                        label: TransactionItem.expense,
                        icon: Icons.north_east_rounded,
                        selected: _type == TransactionItem.expense,
                        color: AppColors.expense,
                        onTap: () => setState(() {
                          _type = TransactionItem.expense;
                          _typeError = null;
                        }),
                      ),
                    ),
                  ],
                ),
                if (_typeError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _typeError!,
                    style: const TextStyle(color: AppColors.expense),
                  ),
                ],
                const SizedBox(height: 18),
                const _SectionLabel('Date'),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('dateField'),
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(18),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101C31),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            formatDate(_date),
                            style: const TextStyle(
                              color: AppColors.cream,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.expand_more_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  key: const Key('saveButton'),
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.cream,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TypeChoice extends StatelessWidget {
  const _TypeChoice({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('type$label'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.18) : AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? color : AppColors.line,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? color : AppColors.muted),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? color : AppColors.cream,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
