import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/domain/usecases/add_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/get_all_expenses.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final AddExpense _addExpense;
  final GetAllExpenses _getAllExpenses;

  ExpensesBloc(
      {required AddExpense addExpense, required GetAllExpenses getAllExpenses})
      : _addExpense = addExpense,
        _getAllExpenses = getAllExpenses,
        super(ExpensesInitial()) {
    on<ExpenseAdd>(_onAddExpensepload);
    on<ExpenseGetAllExpenses>(_onFetchAllExpenses);
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
}
