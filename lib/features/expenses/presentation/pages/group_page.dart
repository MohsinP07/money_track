import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _groupDescController = TextEditingController();
  TextEditingController _groupBudgetController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  String? _selectedUser;
  String? _selectedUserName;

  @override
  void initState() {
    super.initState();
    // Trigger the event to get all users
    BlocProvider.of<AuthBloc>(context).add(AuthGetAllUsers());
  }

  addGroupSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Group',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.cancel,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    hintText: "Group Name",
                    controller: _groupNameController,
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    hintText: "Group Description",
                    controller: _groupDescController,
                  ),
                  const SizedBox(height: 10),
                  CommonTextField(
                    hintText: "Group Budget",
                    controller: _groupBudgetController,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        const Text("Add Members"),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppPallete.borderColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is AuthGetAllUsersSuccess) {
                                List<User> users = state.users;
            
                                return Column(
                                  children: [
                                    TextField(
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        hintText: 'Search users...',
                                      ),
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    if (_searchController.text.isNotEmpty)
                                      ListView(
                                        shrinkWrap: true,
                                        children: users
                                            .where((user) => user.name
                                                .toLowerCase()
                                                .contains(_searchController.text
                                                    .toLowerCase()))
                                            .map((user) {
                                          return ListTile(
                                            title: Text(user.name),
                                            onTap: () {
                                              setState(() {
                                                _selectedUser = user.id;
                                                _selectedUserName = user.name;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    if (_searchController.text.isEmpty)
                                      const SizedBox(
                                        height: 100,
                                        child: Center(
                                          child: Text("No users found."),
                                        ),
                                      ),
                                  ],
                                );
                              }
                              return const Text("No users found.");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_groupNameController.text.isEmpty ||
                          _groupDescController.text.isEmpty ||
                          _groupBudgetController.text.isEmpty ||
                          _selectedUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }
            
                      // Add group logic here
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create Group'),
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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: const [],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppPallete.borderColor,
        label: Row(
          children: const [
            Icon(Icons.add),
            Text("Add Group"),
          ],
        ),
        onPressed: addGroupSheet,
      ),
    );
  }
}
