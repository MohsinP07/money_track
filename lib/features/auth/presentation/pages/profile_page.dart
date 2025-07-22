import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/ai_assistance_tile.dart';
import 'package:money_track/features/auth/presentation/widgets/profile_details.dart';
import 'package:money_track/features/settings/presentation/pages/settings_page.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

class ProfilePage extends StatefulWidget {
  static const String routename = '/profile-page';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _refreshProfile() async {
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      final currentUser = state.user;
      context.read<AppUserCubit>().refreshUser(currentUser);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      final userName = state.user.name;

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
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(SettingsPage.routename);
                              },
                              icon: const Icon(
                                Icons.settings,
                              )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: deviceSize(context).height * 0.01,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppPallete.boxColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppPallete.boxColor,
                        radius: deviceSize(context).width * 0.16,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : '',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 34,
                            color: AppPallete.whiteColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize(context).height * 0.04,
                  ),
                  const ProfileDetails(fileName: "Profile"),
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
                      child: const AiAssistance(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Lottie.asset('assets/shimmers/mt_loading.json'),
        ),
      );
    }
  }
}
