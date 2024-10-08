part of 'expenses_bloc.dart';

abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesFailure extends ExpensesState {
  final String error;

  ExpensesFailure(this.error);
}

class AddExpensesSuccess extends ExpensesState {}

class ExpensesDisplaySuccess extends ExpensesState {
  final List<Expense> expenses;

  ExpensesDisplaySuccess(this.expenses);
}

class DeleteExpensesSuccess extends ExpensesState {
  final Expense deletedExpense;

  DeleteExpensesSuccess(this.deletedExpense);
}

class EditExpensesSuccess extends ExpensesState {
  final Expense editedExpense;

  EditExpensesSuccess(this.editedExpense);
}
