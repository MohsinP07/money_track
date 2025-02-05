import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<Map<String, dynamic>> _expenses = [];
  String currentUserEmail = "";
  String currentUserName = "";
  @override
  void initState() {
    super.initState();
    currentUserEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    currentUserName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    print(currentUserEmail);
    print(currentUserName);
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedExpenses =
        prefs.getString('group_expenses_${widget.group.groupName}');
    if (storedExpenses != null) {
      setState(() {
        _expenses = List<Map<String, dynamic>>.from(jsonDecode(storedExpenses));
      });
    }
  }

  Future<void> _addExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = {
        "_id": const Uuid().v4(),
        "expenseAmount": double.tryParse(_expenseController.text) ?? 0,
        "expenseDescription": _expenseDescriptionController.text.toString(),
        "spendorName": currentUserName,
        "spendorEmail": currentUserEmail,
        "spenderGroup": widget.group.groupName,
      };

      setState(() {
        _expenses.add(expense);
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'group_expenses_${widget.group.groupName}', jsonEncode(_expenses));
      
      _expenseController.clear();
      _expenseDescriptionController.clear();
      Navigator.of(context).pop();
    }
  }

  addExpenseBox(BuildContext context, Size deviceSize) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              title: Text("Add Expense in group"),
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
                      CustomButton(text: 'Add', onTap: _addExpense),
                      CustomButton(
                          text: 'Close',
                          bgColor: AppPallete.errorColor,
                          onTap: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
              ));
        });
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                final bool isSentByUser =
                    expense['spendorName'] == currentUserName;
                return Align(
                  alignment: isSentByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSentByUser
                            ? Colors.greenAccent[100]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                            isSentByUser ? "You" : "${expense['spendorName']}"),
                        subtitle: SizedBox(
                            width: double.infinity,
                            height: deviceSize.height * 0.08,
                            child: Column(
                              children: [
                                Text("₹${expense['expenseAmount']}"),
                                Text("${expense['expenseDescription']}"),
                              ],
                            )),
                      )),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            addExpenseBox(context, deviceSize);
          },
          label: Text("Add ")),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _expenseController.dispose();
    _expenseDescriptionController.dispose();
  }
}
