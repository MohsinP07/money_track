import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/domain/usecases/add_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/delete_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/edit_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/get_all_expenses.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final AddExpense _addExpense;
  final GetAllExpenses _getAllExpenses;
  final DeleteExpense _deleteExpense;
  final EditExpense _editExpense;

  ExpensesBloc({
    required AddExpense addExpense,
    required GetAllExpenses getAllExpenses,
    required DeleteExpense deleteExpense,
    required EditExpense editExpense,
  })  : _addExpense = addExpense,
        _getAllExpenses = getAllExpenses,
        _deleteExpense = deleteExpense,
        _editExpense = editExpense,
        super(ExpensesInitial()) {
    on<ExpenseAdd>(_onAddExpensepload);
    on<ExpenseGetAllExpenses>(_onFetchAllExpenses);
    on<ExpenseDelete>(_onDeleteExpense);
    on<ExpenseEdit>(_onEditExpense);
  }

  void _onAddExpensepload(ExpenseAdd event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoading()); // Emit loading state before processing
    final res = await _addExpense(AddExpenseParams(
      expenserId: event.expenserId,
      expenserName: event.expenserName,
      name: event.name,
      description: event.description,
      amount: event.amount,
      date: event.date,
      category: event.category,
    ));

    res.fold(
      (failure) => emit(ExpensesFailure(failure.message)),
      (expense) =>
          emit(AddExpensesSuccess()), // Pass the expense data on success
    );
  }

  void _onFetchAllExpenses(
      ExpenseGetAllExpenses event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoading()); // Emit loading state before processing
    final res = await _getAllExpenses(NoParams());
    res.fold(
        (l) => emit(ExpensesFailure(l.message)),
        (r) => emit(
              ExpensesDisplaySuccess(r),
            ));
  }

  Future<void> _onDeleteExpense(
      ExpenseDelete event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoading());
    final result = await _deleteExpense(DeleteExpenseParams(id: event.id));
    result.fold(
      (failure) => emit(ExpensesFailure(failure.message)),
      (deletedExpense) => emit(DeleteExpensesSuccess(deletedExpense)),
    );
  }

  Future<void> _onEditExpense(
      ExpenseEdit event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoading()); // Emit loading state before processing
    final result = await _editExpense(EditExpenseParams(
      id: event.id,
      name: event.name,
      description: event.description,
      amount: event.amount,
      date: event.date,
      category: event.category,
    ));
    result.fold(
      (failure) => emit(ExpensesFailure(failure.message)),
      (editedExpense) => emit(EditExpensesSuccess(editedExpense)),
    );
  }
}
