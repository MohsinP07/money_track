import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

class DeleteAllExpensesData extends StatefulWidget {
  const DeleteAllExpensesData({super.key});

  @override
  State<DeleteAllExpensesData> createState() => _DeleteAllExpensesDataState();
}

class _DeleteAllExpensesDataState extends State<DeleteAllExpensesData> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      final id = state.user.id;
      return AlertDialog(
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        content: Container(
          height: deviceSize(context).height * 0.28,
          width: deviceSize(context).width * 0.4,
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                // Show a loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      Center(child: CircularProgressIndicator()),
                );
              } else if (state is AuthDeleteAllExpenseSuccess) {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All expenses deleted successfully')),
                );
              } else if (state is AuthFailure) {
                Navigator.of(context).pop(); // Close the loading dialog
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Delete All Expenses data?"),
                CustomButton(
                  text: 'Delete',
                  onTap: () {
                    // Dispatch the delete all expenses event
                    context.read<AuthBloc>().add(
                          AuthDeleteAllExpenses(
                            expenserId: id,
                          ),
                        );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
