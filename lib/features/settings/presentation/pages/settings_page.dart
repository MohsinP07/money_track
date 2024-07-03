import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/custom_dialog.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:money_track/features/settings/presentation/widgets/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  static const String routename = '/settings-page';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showCustomDialog(BuildContext context, VoidCallback onView) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          icon: Icons.logout,
          submitName: "Logout",
          title: 'Logout',
          content: 'Are you sure you want to logout?',
          onView: onView,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: deviceSize(context).width,
            height: deviceSize(context).height * 0.16,
            decoration: const BoxDecoration(
              color: AppPallete.borderColor,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: deviceSize(context).height * 0.04),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppPallete.whiteColor,
                      )),
                  SizedBox(
                    width: deviceSize(context).width * 0.26,
                  ),
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 22,
                      color: AppPallete.whiteColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'General',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SettingsTile(
                    leadingIcon: Icons.translate,
                    title: 'Language',
                    trailingText: 'English',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                SettingsTile(
                    leadingIcon: Icons.notifications,
                    title: 'Notifications',
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                SettingsTile(
                    leadingIcon: Icons.money,
                    title: 'Currency',
                    trailingText: 'Rupee',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                const Divider(),
                const Text(
                  'Account & Security',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SettingsTile(
                    leadingIcon: Icons.person,
                    title: 'Account Information',
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                SettingsTile(
                    leadingIcon: Icons.password,
                    title: 'Change Password',
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                SettingsTile(
                    leadingIcon: Icons.data_array,
                    title: 'Data',
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                const Divider(),
                const Text(
                  'Other',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SettingsTile(
                    leadingIcon: Icons.lock,
                    title: 'Privacy Policy',
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                SettingsTile(
                    leadingIcon: Icons.list_alt,
                    title: 'Terms & Conditions',
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                SettingsTile(
                    leadingIcon: Icons.group,
                    title: 'About Us',
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {}),
                const Divider(),
                SettingsTile(
                    leadingIcon: Icons.app_registration_sharp,
                    title: 'App Version',
                    trailingText: '1.0.0',
                    trailingIcon: Icons.update,
                    onTrailingIconPressed: () {}),
                const Divider(),
                GestureDetector(
                  onTap: () {
                    _showCustomDialog(context, () {
                      context
                          .read<AuthBloc>()
                          .add(AuthLogout(context: context));
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: deviceSize(context).height * 0.06,
                      decoration: BoxDecoration(
                          color: AppPallete.errorColor,
                          borderRadius: BorderRadius.circular(
                            10,
                          )),
                      child: const Center(
                          child: Text(
                        "Log Out",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppPallete.whiteColor,
                        ),
                      )),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
