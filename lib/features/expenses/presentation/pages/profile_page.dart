import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0).copyWith(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  maxLines: 2,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "User ",
                        style: TextStyle(
                          color: AppPallete.blackColor,
                          fontSize: 30,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: "Name",
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
                IconButton(
                    onPressed: () {
                      context.read<AppUserCubit>().clearUser();
                    },
                    icon: const Icon(
                      Icons.logout,
                    ))
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
                    child: const Text(
                      'U',
                      style: TextStyle(
                        fontSize: 32,
                        color: AppPallete.whiteColor,
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        6,
                      ),
                    ),
                    elevation: 10,
                    child: SizedBox(
                      width: deviceSize(context).width * 0.8,
                      child: ListTile(
                        trailing: CircleAvatar(
                          backgroundColor: AppPallete.boxColor,
                          radius: deviceSize(context).width * 0.044,
                          child: const Text(
                            '4',
                            style: TextStyle(
                              color: AppPallete.whiteColor,
                            ),
                          ),
                        ),
                        title: const Text(
                          "Trasactions",
                          style: TextStyle(fontSize: 12),
                        ),
                        subtitle: const Text(
                          'Your transcations this month',
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
                "User",
                style: TextStyle(fontSize: 12),
              ),
            ),
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
            ),
            const Divider(),
            SizedBox(
              height: deviceSize(context).height * 0.02,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  6,
                ),
              ),
              elevation: 10,
              child: SizedBox(
                width: deviceSize(context).width * 0.9,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppPallete.boxColor,
                    radius: deviceSize(context).width * 0.06,
                    child: const Center(
                        child: Icon(
                      FontAwesomeIcons.robot,
                      color: AppPallete.whiteColor,
                    )),
                  ),
                  title: const Text(
                    "Artificial Intelegence",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: const Text(
                    'Get suggestions with help of AI for better savings',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
