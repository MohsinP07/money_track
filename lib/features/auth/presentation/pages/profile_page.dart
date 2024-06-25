import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:money_track/features/auth/presentation/widgets/ai_assistance_tile.dart';
import 'package:money_track/features/auth/presentation/widgets/profile_details.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _refreshProfile() async {
    final currentUser =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<AppUserCubit>().refreshUser(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        (context.watch<AppUserCubit>().state as AppUserLoggedIn).user.name;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0).copyWith(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${userName.split(' ').first} ",
                            style: const TextStyle(
                              color: AppPallete.blackColor,
                              fontSize: 30,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: userName.split(' ').sublist(1).join(' '),
                            style: const TextStyle(
                              color: AppPallete.blackColor,
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(AuthLogout(context: context));
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceSize(context).height * 0.01,
                ),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppPallete.boxColor,
                        radius: deviceSize(context).width * 0.16,
                        child: Text(
                          userName.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 32,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 10,
                        child: SizedBox(
                          width: deviceSize(context).width * 0.8,
                          child: ListTile(
                            trailing: CircleAvatar(
                              backgroundColor: AppPallete.boxColor,
                              radius: deviceSize(context).width * 0.044,
                              child: const Text(
                                '0',
                                style: TextStyle(
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                            ),
                            title: const Text(
                              "Transactions",
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: const Text(
                              'Your transactions this month',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceSize(context).height * 0.04,
                ),
                ProfileDetails(),
                const Divider(),
                SizedBox(
                  height: deviceSize(context).height * 0.02,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 10,
                  child: SizedBox(
                      width: deviceSize(context).width * 0.9,
                      child: AiAssistance()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
