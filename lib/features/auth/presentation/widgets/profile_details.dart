import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/edit_profile_sheet.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

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
            children: [
              TextButton(
                  onPressed: () {
                    _showEditBottomSheet(context, user);
                  },
                  child: const Text("Edit Profile")),
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
            ],
          );
        }
        return Container();
      },
    );
  }
}
