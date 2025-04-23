import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';
import 'package:money_track/features/group/presentation/pages/group_page.dart';

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
  List<User> _selectedMembersToAdd = [];
  final TextEditingController _searchController = TextEditingController();
  var adminEmail = '';
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    adminEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    userName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    BlocProvider.of<AuthBloc>(context).add(AuthGetAllUsers());
  }

  void _addUser(User user) {
    if (!_selectedMembersToAdd.contains(user)) {
      setState(() {
        _selectedMembersToAdd.add(user);
      });
    }
  }

  void _removeUser(User user) {
    setState(() {
      _selectedMembersToAdd.remove(user);
    });
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Edit Group'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildInputField(nameController, 'Group Name'),
                const SizedBox(height: 8),
                _buildInputField(descriptionController, 'Group Description'),
                const SizedBox(height: 8),
                _buildInputField(
                  budgetController,
                  'Budget',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppPallete.borderColor,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppPallete.borderColor),
              ),
              onPressed: () {
                final newName = nameController.text.trim();
                final newDescription = descriptionController.text.trim();
                final newBudget = double.tryParse(budgetController.text.trim());

                if (newName.isEmpty || newBudget == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please provide valid details.')),
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

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _removeMember(String memberEmail) {
    if (adminName == userName) {
      Navigator.of(context).pop();
      BlocProvider.of<GroupBloc>(context).add(GroupRemoveMember(
        groupId: widget.group.id!,
        memberId: memberEmail,
      ));
      print("Removing member...");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only the admin can remove members.")),
      );
    }
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppPallete.borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  showRemoveDialog(BuildContext context, String member, String memberEmail) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Confirm remove?"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.1,
              child:
                  Text("Are you sure you want to remove $member from group?"),
            ),
            actions: [
              CustomButton(
                  text: "Remove",
                  onTap: () {
                    _removeMember(memberEmail);
                    Navigator.of(context).pushNamed(GroupPage.routeName);
                  }),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: AppPallete.borderColor,
                    ),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        backgroundColor: AppPallete.borderColor,
        elevation: 2,
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
              if (state is GroupFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("Failed to add/remove member: ${state.error}")),
                );
              } else if (state is AddMemberSuccess) {
                final updatedGroup = state.updatedGroup;
                setState(() {
                  widget.group.members = updatedGroup.members;
                  _selectedMembersToAdd.clear();
                });

                BlocProvider.of<AuthBloc>(context).add(AuthGetAllUsers());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Member added successfully!")),
                );
              } else if (state is RemoveMemberSuccess) {
                final updatedGroup = state.updatedGroup;
                setState(() {
                  widget.group.members = updatedGroup.members;
                  _selectedMembersToAdd.clear();
                });

                BlocProvider.of<AuthBloc>(context).add(AuthGetAllUsers());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Member removed successfully!")),
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
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AuthGetAllUsersSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGroupCard(),
                    const SizedBox(height: 20),
                    _buildInfoSection("Admin",
                        '$adminName${adminName == userName ? " - You" : ""}'),
                    const SizedBox(height: 12),
                    _buildInfoSection("Members", "", children: [
                      if (widget.group.members.isEmpty)
                        const Text("No members added."),
                      ...widget.group.members.map((memberEmail) {
                        final member = users.firstWhere(
                          (user) => user.email == memberEmail,
                          orElse: () =>
                              User(id: '', name: "Anonymous", email: ""),
                        );
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: AppPallete.borderColor,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(member.name),
                          trailing:
                              adminName != member.name && adminName == userName
                                  ? IconButton(
                                      onPressed: () {
                                        showRemoveDialog(
                                            context, member.name, member.email);
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline_sharp,
                                        color: AppPallete.errorColor,
                                      ),
                                    )
                                  : null,
                        );
                      })
                    ]),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(
                            color: AppPallete.borderColor.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: ListTile(
                        title: const Text(
                          "Add Members",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 32,
                            color: AppPallete.borderColor,
                          ),
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Container(
                        child: Column(
                          children: [
                            if (_selectedMembersToAdd.isNotEmpty)
                              Container(
                                height: 60,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedMembersToAdd.length,
                                  itemBuilder: (context, index) {
                                    final user = _selectedMembersToAdd[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppPallete.borderColor),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[200],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(user.name),
                                          const SizedBox(width: 5),
                                          if (user.email != adminEmail)
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
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppPallete.borderColor),
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
                                                EdgeInsets.symmetric(
                                                    horizontal: 10),
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
                                                    user.email != adminEmail &&
                                                    user.name
                                                        .toLowerCase()
                                                        .contains(
                                                            _searchController
                                                                .text
                                                                .toLowerCase()) &&
                                                    !widget.group.members
                                                        .contains(user.email))
                                                .map((user) {
                                              return ListTile(
                                                title: Text(user.name),
                                                trailing: !_selectedMembersToAdd
                                                            .contains(user) &&
                                                        _selectedMembersToAdd !=
                                                            widget.group.members
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons.add,
                                                            color:
                                                                Colors.green),
                                                        onPressed: () =>
                                                            _addUser(user),
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
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              child: CustomButton(
                                  text: "Add Members",
                                  onTap: () {
                                    print(
                                      _selectedMembersToAdd
                                          .map((user) => user.email)
                                          .toList(),
                                    );

                                    BlocProvider.of<GroupBloc>(context)
                                        .add(GroupAddMember(
                                      groupId: widget.group.id!,
                                      members: _selectedMembersToAdd
                                          .map((user) => user.email)
                                          .toList(),
                                    ));
                                  }),
                            )
                          ],
                        ),
                      ),
                  ],
                );
              }

              return const Center(child: Text("Failed to load group info"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard() {
    return Card(
      color: AppPallete.buttonColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.groupName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.whiteColor,
                )),
            const SizedBox(height: 8),
            Text(
              widget.group.groupDescription.isNotEmpty
                  ? widget.group.groupDescription
                  : "No description available.",
              style: TextStyle(color: Colors.grey[900]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.money, color: AppPallete.borderColor),
                const SizedBox(width: 6),
                Text(
                  "Budget: ${widget.group.budget}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String value,
      {List<Widget>? children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 6),
        if (value.isNotEmpty) Text(value, style: const TextStyle(fontSize: 16)),
        if (children != null) ...children,
      ],
    );
  }
}
