import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';
import 'package:money_track/features/group/presentation/widgets/add_group_page.dart';
import 'package:money_track/features/group/presentation/widgets/group_chat_screen.dart';

class GroupPage extends StatefulWidget {
  static const String routeName = "group-page";
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late Timer _groupCheckTimer;
  var userEmail = '';
  var userGroups = [];
  @override
  void initState() {
    super.initState();
    userEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;

    BlocProvider.of<GroupBloc>(context).add(GroupsGetAllGroups());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupFailure) {
            showSnackBar(context, state.error);
          } else if (state is DeleteGroupSuccess) {
            showSnackBar(context, 'Group Deleted');
            context.read<GroupBloc>().add(GroupsGetAllGroups());
          }
        },
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Loader();
          }
          if (state is GroupsDisplaySuccess) {
            final userGroups = state.groups
                .where((group) => group.members.contains(userEmail))
                .toList();

            if (userGroups.isEmpty) {
              return const Center(
                child: Text(
                  "No groups available for you.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0).copyWith(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 2,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Your",
                            style: TextStyle(
                              color: AppPallete.blackColor,
                              fontSize: 30,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: "Groups",
                            style: TextStyle(
                              color: AppPallete.blackColor,
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: userGroups.length,
                        itemBuilder: (context, index) {
                          final group = userGroups[index];
                          return Dismissible(
                            key: Key(group.id!),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              color: AppPallete.errorColor,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              bool? result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Group?"),
                                    content: Text(
                                      "Are you sure you want to delete '${group.groupName}'?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: AppPallete.errorColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return result ?? false;
                            },
                            onDismissed: (direction) {
                              context
                                  .read<GroupBloc>()
                                  .add(GroupDelete(id: group.id!));
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  GroupChatScreen.routeName,
                                  arguments: group,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: AppPallete.botBgColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          group.groupName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          group.groupDescription,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Budget: ${group.budget}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppPallete.borderColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        label: Row(
          children: const [
            Icon(Icons.add),
            Text("Add Group"),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AddGroupPage.routeName);
        },
      ),
    );
  }
}
