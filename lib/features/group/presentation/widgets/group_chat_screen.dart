import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';
import 'package:money_track/features/group/presentation/widgets/group_info_screen.dart';
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
  double totalExpenseAmount = 0.0;
  double addedExpense = 0.0;
  bool budgetExceeded = false;

  @override
  void initState() {
    super.initState();
    currentUserEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    currentUserName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    expenses = List.from(widget.group.groupExpenses ?? []);
    print(expenses);
    expenses.sort((a, b) {
      final dateA = DateTime.parse(a['expenseDate']);
      final dateB = DateTime.parse(b['expenseDate']);
      return dateB.compareTo(dateA); // Descending
    });

    for (int i = 0; i < expenses.length; i++) {
      totalExpenseAmount += expenses[i]['expenseAmount'];
    }
    print("Total $totalExpenseAmount");
  }

  void _addExpense(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      newExpense = {
        "_id": const Uuid().v4(),
        "expenseDate": DateTime.now().toString(),
        "expenseAmount": double.tryParse(_expenseController.text) ?? 0,
        "expenseDescription": _expenseDescriptionController.text,
        "spendorName": currentUserName,
        "spendorEmail": currentUserEmail,
        "spenderGroup": widget.group.groupName,
      };
      print('Checkk $newExpense');

      setState(() {
        expenses.insert(0, newExpense);
        totalExpenseAmount += newExpense['expenseAmount'];
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
        return StatefulBuilder(
          builder: (context, setState) {
            // Listen to controller changes
            _expenseController.addListener(() {
              final value = double.tryParse(_expenseController.text.trim());
              setState(() {
                addedExpense = value ?? 0;
              });
            });

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
                    ),
                  ),
                ],
              ),
              content: Container(
                width: deviceSize.width * 0.7,
                height: deviceSize.height * 0.45,
                padding: const EdgeInsets.all(2),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
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
                        if (_expenseController.text.isNotEmpty) ...[
                          Text(
                            "Total expenses: ${totalExpenseAmount + (double.tryParse(_expenseController.text) ?? 0)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if ((totalExpenseAmount +
                                  (double.tryParse(_expenseController.text) ??
                                      0)) >
                              double.parse(widget.group.budget))
                            const Text(
                              "⚠️ Budget exceeded! Cannot save changes.",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                        ],
                        CustomButton(
                          text: 'Save Changes',
                          onTap: () {
                            final updatedExpense = {
                              ...expense,
                              'expenseAmount':
                                  double.tryParse(_expenseController.text) ?? 0,
                              'expenseDescription':
                                  _expenseDescriptionController.text
                            };
                            final budget =
                                double.tryParse(widget.group.budget) ?? 0;
                            final newTotal = totalExpenseAmount -
                                expense['expenseAmount'] +
                                updatedExpense['expenseAmount'];

                            if (newTotal <= budget) {
                              setState(() {
                                totalExpenseAmount -= expense['expenseAmount'];
                                totalExpenseAmount +=
                                    updatedExpense['expenseAmount'];
                                expenses[expenses.indexOf(expense)] =
                                    updatedExpense;
                              });

                              context.read<GroupBloc>().add(
                                  GroupEditGroupExpense(
                                      groupId: widget.group.id!,
                                      expenseId: expense['_id'],
                                      updatedExpense: updatedExpense
                                          as Map<String, Object>));

                              _expenseController.clear();
                              _expenseDescriptionController.clear();
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                budgetExceeded = true;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        CustomButton(
                          text: 'Delete Expense',
                          bgColor: AppPallete.errorColor,
                          onTap: () {
                            final budget =
                                double.tryParse(widget.group.budget) ?? 0;
                            final newTotal =
                                totalExpenseAmount - expense['expenseAmount'];

                            if (newTotal <= budget) {
                              context.read<GroupBloc>().add(
                                    GroupDeleteGroupExpense(
                                      groupId: widget.group.id!,
                                      expenseId: expense['_id'],
                                    ),
                                  );

                              setState(() {
                                totalExpenseAmount -= expense['expenseAmount'];
                                expenses.removeWhere((element) =>
                                    element['_id'] == expense['_id']);
                              });

                              _expenseController.clear();
                              _expenseDescriptionController.clear();
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                budgetExceeded = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addExpenseBox(BuildContext context, Size deviceSize) {
    showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, setState) {
            _expenseController.addListener(() {
              final value = double.tryParse(_expenseController.text.trim());
              setState(() {
                addedExpense = value ?? 0;
              });
            });

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
                        onTap: () {
                          final budget =
                              double.tryParse(widget.group.budget) ?? 0;
                          if ((totalExpenseAmount + addedExpense) <= budget) {
                            _addExpense(context);
                          }
                        },
                      ),
                      CustomButton(
                        text: 'Close',
                        bgColor: AppPallete.errorColor,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      if (_expenseController.text.isNotEmpty) ...[
                        Text(
                          "Total expenses: ${totalExpenseAmount + (double.tryParse(_expenseController.text) ?? 0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if ((totalExpenseAmount +
                                (double.tryParse(_expenseController.text) ??
                                    0)) >
                            double.parse(widget.group.budget))
                          const Text(
                            "⚠️ Budget exceeded! Cannot add more expenses.",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
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
                  "${widget.group.members.length} members  Budget: ${widget.group.budget}",
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
                (expense) {
                  final updatedExpense =
                      state.updatedGroup.groupExpenses?.firstWhere(
                    (e) => e['_id'] == expense['_id'],
                    orElse: () => {},
                  );

                  if (updatedExpense == null) return false;

                  return expense['_id'] == updatedExpense['_id'];
                },
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
                      return Container();
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
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: isSentByUser
                            ? Colors.green.shade50
                            : Colors.purple.shade50,
                        child: Container(
                          constraints: const BoxConstraints(
                              maxWidth: 320), // Set a max width
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense['expenseDescription'] ??
                                    "No description",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.money,
                                    color: Colors.black54,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "\₹${expense['expenseAmount'] ?? 0.0}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Date: ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(expense['expenseDate']))}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              if (isSentByUser) ...[
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () => _editDeleteExpense(
                                        context,
                                        expense,
                                        MediaQuery.of(context).size,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.green[700],
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                      child: Builder(builder: (context) {
                        final budget =
                            double.tryParse(widget.group.budget) ?? 0;
                        final percentage =
                            budget > 0 ? totalExpenseAmount / budget : 0;

                        Color textColor = Colors.grey[700]!;
                        if (percentage >= 0.9) {
                          textColor = Colors.red;
                        } else if (percentage >= 0.65) {
                          textColor = Colors.amber;
                        }

                        return Text(
                          "Total Expenses: ₹$totalExpenseAmount",
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                    ),
                    CustomButton(
                      text: 'Add Expense',
                      onTap: () => addExpenseBox(context, deviceSize),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
