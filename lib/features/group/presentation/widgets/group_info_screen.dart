import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';
import 'package:money_track/features/group/presentation/pages/group_page.dart';
import 'package:money_track/features/group/presentation/widgets/edit_group_dialog.dart';

class GroupInfoScreen extends StatefulWidget {
  final GroupEntity group;

  const GroupInfoScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  var adminName = '';
  var userName = '';
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    userName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    BlocProvider.of<AuthBloc>(context).add(AuthGetAllUsers());
  }

  void _showEditGroupDialog() {
    final nameController = TextEditingController(text: widget.group.groupName);
    final descriptionController =
        TextEditingController(text: widget.group.groupDescription);
    final budgetController =
        TextEditingController(text: widget.group.budget.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Group'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Group Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Group Description'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Budget'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                final newDescription = descriptionController.text.trim();
                final newBudget = double.tryParse(budgetController.text.trim());

                if (newName.isEmpty || newBudget == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide valid details.'),
                    ),
                  );
                  return;
                }

                BlocProvider.of<GroupBloc>(context).add(
                  GroupEdit(
                    id: widget.group.id!,
                    groupName: newName,
                    groupDescription: newDescription,
                    budget: newBudget.toString(),
                  ),
                );

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditGroupDialog,
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GroupBloc, GroupState>(
            listener: (context, state) {
              if (state is EditGroupSuccess) {
                final updatedGroup = state.editedGroup;
                setState(() {
                  widget.group.groupName = updatedGroup.groupName.isNotEmpty
                      ? updatedGroup.groupName
                      : widget.group.groupName;
                  widget.group.groupDescription =
                      updatedGroup.groupDescription.isNotEmpty
                          ? updatedGroup.groupDescription
                          : widget.group.groupDescription;
                  widget.group.budget = updatedGroup.budget;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Group updated successfully!")),
                );

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BottomBar(initialPage: 3)));
              } else if (state is GroupFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Failed to update group: ${state.error}")),
                );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthGetAllUsersSuccess) {
                setState(() {
                  users = state.users;
                  adminName = users
                      .firstWhere(
                        (user) => user.email == widget.group.admin,
                        orElse: () =>
                            User(id: '', name: "Anonymous", email: ""),
                      )
                      .name;
                });
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is AuthGetAllUsersSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.group.groupName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.group.groupDescription.isNotEmpty
                          ? widget.group.groupDescription
                          : "No description available.",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Budget: ${widget.group.budget}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const Text(
                      "Admin",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '$adminName ${adminName == userName ? "- You" : ""}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const Text(
                      "Members",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.group.members.isEmpty)
                      const Text(
                        "No members added to this group.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ...widget.group.members.map<Widget>((memberEmail) {
                      final matchingUser = users.firstWhere(
                        (user) => user.email == memberEmail,
                        orElse: () =>
                            User(id: '', name: "Anonymous", email: ""),
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              matchingUser.name.isNotEmpty
                                  ? matchingUser.name
                                  : "Anonymous",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              }

              return const Center(
                child: Text("Failed to load group info"),
              );
            },
          ),
        ),
      ),
    );
  }
}
