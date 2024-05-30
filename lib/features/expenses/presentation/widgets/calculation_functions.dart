import 'package:money_track/features/expenses/domain/entity/expense.dart';

class CalculationFunctions {
  static double calculateTodaysExpense(List<Expense> todayExpenses) {
    double total = 0;

    for (var expense in todayExpenses) {
      total += double.tryParse(expense.amount) ?? 0.0;
    }
    return total;
  }

  static double calculateWeeklyExpense(List<Expense> expenses) {
    double total = 0;
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: 7));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    for (var expense in expenses) {
      final expenseDate = expense.date;
      if (expenseDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          expenseDate.isBefore(endOfWeek.add(Duration(days: 1)))) {
        total += double.tryParse(expense.amount) ?? 0.0;
      }
    }
    return total;
  }

  static double calculateMonthlyExpense(List<Expense> expenses) {
    double total = 0;
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);

    for (var expense in expenses) {
      final expenseDate = expense.date;
      if (expenseDate.isAfter(startOfMonth.subtract(Duration(days: 1))) &&
          expenseDate.isBefore(today.add(Duration(days: 1)))) {
        total += double.tryParse(expense.amount) ?? 0.0;
      }
    }
    return total;
  }

  static String decideIcon(String category) {
    switch (category) {
      case 'Household':
        return 'assets/images/household.png';
      case 'Food':
        return 'assets/images/food.png';
      case 'Entertainment':
        return 'assets/images/entertainment.png';
      case 'Wellness':
        return 'assets/images/wellness.png';
      case 'Grocery':
        return 'assets/images/grocery.png';
      case 'All':
        return 'assets/images/all.png';
      default:
        return 'assets/images/bills.png';
    }
  }
}
