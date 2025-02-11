import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';
import 'package:money_track/features/group/presentation/widgets/group_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

class GroupChatScreen extends StatefulWidget {
  static const String routeName = "group-chat-screen";
  final GroupEntity group;

  const GroupChatScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _expenseDescriptionController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String currentUserEmail;
  late String currentUserName;
  var expenses = [];
  var newExpense;

  @override
  void initState() {
    super.initState();
    currentUserEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    currentUserName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    expenses = List.from(widget.group.groupExpenses ?? []);
  }

  void _addExpense(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      newExpense = {
        "_id": const Uuid().v4(),
        "expenseAmount": double.tryParse(_expenseController.text) ?? 0,
        "expenseDescription": _expenseDescriptionController.text,
        "spendorName": currentUserName,
        "spendorEmail": currentUserEmail,
        "spenderGroup": widget.group.groupName,
      };

      setState(() {
        expenses.insert(0, newExpense);
      });

      context.read<GroupBloc>().add(GroupAddGroupExpenses(
          id: widget.group.id!, groupExpenses: newExpense));

      _expenseController.clear();
      _expenseDescriptionController.clear();
      Navigator.of(context).pop();
    }
  }

  void _editDeleteExpense(
      BuildContext context, Map<String, dynamic> expense, Size deviceSize) {
    _expenseController.text = expense['expenseAmount'].toString();
    _expenseDescriptionController.text = expense['expenseDescription'];

    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Edit Expense"),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppPallete.errorColor,
                  ))
            ],
          ),
          content: Container(
            width: deviceSize.width * 0.7,
            height: deviceSize.height * 0.4,
            padding: const EdgeInsets.all(2),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonTextField(
                    hintText: "Expense Amount",
                    controller: _expenseController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  CommonTextField(
                    hintText: "Expense Description",
                    controller: _expenseDescriptionController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  CustomButton(
                    text: 'Save Changes',
                    onTap: () {
                      final updatedExpense = {
                        ...expense,
                        'expenseAmount':
                            double.tryParse(_expenseController.text) ?? 0,
                        'expenseDescription': _expenseDescriptionController.text
                      };

                      setState(() {
                        expenses[expenses.indexOf(expense)] = updatedExpense;
                      });
                      print("Check gere");
                      print(expense['_id']);
                      context.read<GroupBloc>().add(GroupEditGroupExpense(
                          groupId: widget.group.id!,
                          expenseId: expense['_id'],
                          updatedExpense:
                              updatedExpense as Map<String, Object>));
                      _expenseController.clear();
                      _expenseDescriptionController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  CustomButton(
                    text: 'Delete Expense',
                    bgColor: AppPallete.errorColor,
                    onTap: () {
                      context.read<GroupBloc>().add(
                            GroupDeleteGroupExpense(
                                groupId: widget.group.id!,
                                expenseId: expense['_id']),
                          );
                      print(expenses);
                      print(expense);
                      setState(() {
                        expenses.removeWhere(
                            (element) => element['_id'] == expense['_id']);
                      });
                      _expenseController.clear();
                      _expenseDescriptionController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void addExpenseBox(BuildContext context, Size deviceSize) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: const Text("Add Expense in group"),
          content: Container(
            width: deviceSize.width * 0.8,
            height: deviceSize.height * 0.4,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CommonTextField(
                    hintText: "Expense Amount",
                    controller: _expenseController,
                    keyboardType: TextInputType.number,
                  ),
                  CommonTextField(
                    hintText: "Expense Description",
                    controller: _expenseDescriptionController,
                    keyboardType: TextInputType.text,
                  ),
                  CustomButton(
                    text: 'Add',
                    onTap: () => _addExpense(context),
                  ),
                  CustomButton(
                    text: 'Close',
                    bgColor: AppPallete.errorColor,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.group.groupName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${widget.group.members.length} members",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupInfoScreen(group: widget.group),
                  ),
                );
              },
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        backgroundColor: AppPallete.borderColor,
        elevation: 0,
      ),
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupFailure) {
            showSnackBar(context, state.error);
          } else if (state is AddGroupExpensesSuccess) {
            showSnackBar(context, 'Group Expenses added!');
            setState(() {
              expenses.insert(0, state.updatedGroup.groupExpenses);
            });
          } else if (state is EditGroupExpenseSuccess) {
            showSnackBar(context, 'Group Expenses edited!');
            setState(() {
              int index = expenses.indexWhere(
                (expense) =>
                    expense['_id'] ==
                    state.updatedGroup.groupExpenses?.firstWhere(
                      (e) => e['_id'] == expense['_id'],
                      orElse: () => {},
                    )['_id'],
              );

              if (index != -1 &&
                  state.updatedGroup.groupExpenses?.isNotEmpty == true) {
                expenses[index] = state.updatedGroup.groupExpenses!.firstWhere(
                  (e) => e['_id'] == expenses[index]['_id'],
                  orElse: () => {},
                );
              }
            });
          } else if (state is DeleteGroupExpenseSuccess) {
            showSnackBar(context, 'Group Expenses deleted!');
            setState(() {
              expenses = List.from(state.updatedGroup.groupExpenses ?? []);
            });
          }
        },
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Loader();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];

                    if (expense is! Map<String, dynamic>) {
                      // Log a warning or handle invalid data gracefully
                      print("Invalid expense data: $expense");
                      return Container(); // Skip rendering for invalid data
                    }

                    final bool isSentByUser =
                        expense['spendorName'] == currentUserName;

                    return Align(
                      alignment: isSentByUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(expense['expenseDescription'] ??
                              "No description"),
                          subtitle: Text(
                              "Amount: ${expense['expenseAmount'] ?? 0.0}"),
                          trailing: isSentByUser
                              ? IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editDeleteExpense(context,
                                      expense, MediaQuery.of(context).size),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomButton(
                  text: 'Add Expense',
                  onTap: () => addExpenseBox(context, deviceSize),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
