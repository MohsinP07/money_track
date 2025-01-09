import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/group/domain/entity/group.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthGetAllUsersSuccess) {
              users = state.users;
              adminName = users
                  .firstWhere(
                    (user) => user.email == widget.group.admin,
                    orElse: () => User(id: '', name: "Anonymous", email: ""),
                  )
                  .name;
            }
          },
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
                      orElse: () => User(id: '', name: "Anonymous", email: ""),
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
    );
  }
}
