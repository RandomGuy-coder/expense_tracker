import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // Stores the text whenever somethind new is typed by the user
  // Need to make sure to dispose the controller when the widget not needed anymore
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leasure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(children: [
        TextField(
          controller: _titleController,
          maxLength: 50,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(label: Text('Title')),
        ),
        amountAndDate(),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            categoryDropDown(),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense'))
          ],
        )
      ]),
    );
  }

  DropdownButton<Category> categoryDropDown() {
    return DropdownButton(
      value: _selectedCategory,
      items: Category.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.name.toUpperCase()),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) {
          // ignore: avoid_returning_null_for_void
          return null;
        }
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Row amountAndDate() {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(prefixText: '\$', label: Text('Amount')),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_selectedDate == null
                ? 'No date selected'
                : formatter.format(_selectedDate!)),
            IconButton(
              onPressed: _presentDatePicker,
              icon: const Icon(Icons.calendar_month),
            )
          ],
        ),
      )
    ]);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1, now.month, now.day),
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text(
                  'Please make sure valid values are selected for all fields.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Okay'))
              ],
            );
          });
      return;
    }

    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));

    Navigator.pop(context);
  }
}
