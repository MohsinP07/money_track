import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';
import 'package:money_track/features/group/presentation/pages/group_page.dart';

class AddGroupPage extends StatefulWidget {
  static const String routeName = "add-group-screen";
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescController = TextEditingController();
  final TextEditingController _groupBudgetController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<User> _selectedUsers = [];
  var adminEmail = '';

  @override
  void initState() {
    super.initState();
    adminEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;

    final adminUser =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    _selectedUsers.add(adminUser);

    BlocProvider.of<AuthBloc>(context).add(AuthGetAllUsers());
  }

  void _addUser(User user) {
    if (!_selectedUsers.contains(user)) {
      setState(() {
        _selectedUsers.add(user);
      });
    }
  }

  void _removeUser(User user) {
    setState(() {
      _selectedUsers.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
        backgroundColor: AppPallete.borderColor,
      ),
      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is AddGroupSuccess) {
            showSnackBar(context, "Group created successfully");
            Navigator.of(context).pushNamed(GroupPage.routeName);
          } else if (state is GroupFailure) {
            showSnackBar(context, state.error);
            print(state.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 20),
              const Text(
                "Add Members",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_selectedUsers.isNotEmpty)
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedUsers.length,
                    itemBuilder: (context, index) {
                      final user = _selectedUsers[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppPallete.borderColor),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(user.name),
                            const SizedBox(width: 5),
                            if (user.email !=
                                adminEmail) // Prevent removal of admin
                              GestureDetector(
                                onTap: () => _removeUser(user),
                                child: const Icon(Icons.close,
                                    size: 16, color: Colors.red),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
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
                                  .where((user) =>
                                      user.email !=
                                          adminEmail && // Exclude admin
                                      user.name.toLowerCase().contains(
                                          _searchController.text.toLowerCase()))
                                  .map((user) {
                                return ListTile(
                                  title: Text(user.name),
                                  trailing: !_selectedUsers.contains(user)
                                      ? IconButton(
                                          icon: const Icon(Icons.add,
                                              color: Colors.green),
                                          onPressed: () => _addUser(user),
                                        )
                                      : null,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_groupNameController.text.isEmpty ||
                      _groupDescController.text.isEmpty ||
                      _groupBudgetController.text.isEmpty ||
                      _selectedUsers.isEmpty) {
                    showSnackBar(context, "Please fill all the fields");
                    return;
                  }

                  context.read<GroupBloc>().add(GroupAdd(
                        groupName: _groupNameController.text,
                        groupDescription: _groupDescController.text,
                        budget: _groupBudgetController.text,
                        admin: adminEmail,
                        members:
                            _selectedUsers.map((user) => user.email).toList(),
                      ));
                },
                child: BlocBuilder<GroupBloc, GroupState>(
                  builder: (context, state) {
                    if (state is GroupLoading) {
                      return const CircularProgressIndicator();
                    }
                    return const Text('Create Group');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
