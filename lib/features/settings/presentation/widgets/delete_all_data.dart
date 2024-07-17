import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
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
        title: const ListTile(
          leading: Icon(
            Icons.delete,
            color: AppPallete.errorColor,
          ),
          title: Text(
            'Clear Data',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: SizedBox(
          height: deviceSize(context).height * 0.28,
          width: deviceSize(context).width * 0.4,
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                const Loader();
              } else if (state is AuthDeleteAllExpenseSuccess) {
                Navigator.of(context).pop();
                showSnackBar(context, 'All expenses deleted successfully');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BottomBar(initialPage: 0)));
              } else if (state is AuthFailure) {
                Navigator.of(context).pop();
                showSnackBar(context, state.message);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Are you sure you want to delete All Expenses data?"),
                SizedBox(
                  height: deviceSize(context).height * 0.06,
                ),
                CustomButton(
                  text: 'Delete',
                  onTap: () {
                    context.read<AuthBloc>().add(
                          AuthDeleteAllExpenses(
                            expenserId: id,
                          ),
                        );
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppPallete.errorColor,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
