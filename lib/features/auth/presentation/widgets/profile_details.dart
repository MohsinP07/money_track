// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/edit_profile_sheet.dart';

class ProfileDetails extends StatelessWidget {
  final String fileName;
  const ProfileDetails({
    Key? key,
    required this.fileName,
  }) : super(key: key);

  void _showEditBottomSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) => EditProfileSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if (state is AppUserLoggedIn) {
          final user = state.user;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fileName == "Profile")
                TextButton(
                    onPressed: () {
                      _showEditBottomSheet(context, user);
                    },
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: AppPallete.boxColor),
                    )),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppPallete.boxColor,
                  radius: deviceSize(context).width * 0.044,
                  child: const Icon(
                    Icons.email,
                    color: AppPallete.whiteColor,
                  ),
                ),
                title: const Text(
                  "Email",
                  style: TextStyle(fontSize: 12),
                ),
                subtitle: Text(user.email),
              ),
              const Divider(),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppPallete.boxColor,
                    radius: deviceSize(context).width * 0.044,
                    child: const Icon(
                      Icons.person,
                      color: AppPallete.whiteColor,
                    ),
                  ),
                  title: const Text(
                    "Name",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(user.name)),
              const Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppPallete.boxColor,
                  radius: deviceSize(context).width * 0.044,
                  child: const Icon(
                    Icons.phone,
                    color: AppPallete.whiteColor,
                  ),
                ),
                title: const Text(
                  "Phone",
                  style: TextStyle(fontSize: 12),
                ),
                subtitle: Text(user.phone),
              ),
              if (fileName == "Settings")
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: SizedBox(
                      height: deviceSize(context).height * 0.06,
                      width: double.infinity,
                      child: CustomButton(
                          text: "Edit Profile",
                          onTap: () {
                            _showEditBottomSheet(context, user);
                          })),
                ),
              if (fileName == "Settings")
                Center(
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
          );
        }
        return Container();
      },
    );
  }
}
