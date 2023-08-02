import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/chart.dart';
import 'package:expense_tracker/screens/expenses_list.dart';
import 'package:expense_tracker/screens/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 19.2,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Road Trip',
      amount: 301.3,
      date: DateTime.now(),
      category: Category.leasure,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(children: [
        Chart(expenses: _registeredExpenses),
        Expanded(
          child: (_registeredExpenses.isNotEmpty)
              ? ExpensesList(
                  expenses: _registeredExpenses,
                  onRemoveExpense: _removeExpense,
                )
              : const Center(
                  child: Text('No expenses found. Start adding some!'),
                ),
        )
      ]),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    //Can be used to clear snackbars if have mutiple items deleted
    /**  ScaffoldMessenger.of(context).clearSnackBars(); */

    // Show snackbar to notify expense deleted and allow UNDO
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(onAddExpense: _addExpense);
        });
  }
}
