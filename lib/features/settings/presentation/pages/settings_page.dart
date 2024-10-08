import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:money_track/core/common/widgets/custom_dialog.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:money_track/features/auth/presentation/widgets/profile_details.dart';
import 'package:money_track/features/settings/presentation/widgets/about_us.dart';
import 'package:money_track/features/settings/presentation/widgets/currency_dialog.dart';
import 'package:money_track/features/settings/presentation/widgets/delete_all_data.dart';
import 'package:money_track/features/settings/presentation/widgets/language_dialog.dart';
import 'package:money_track/features/settings/presentation/widgets/privacy_policy.dart';
import 'package:money_track/features/settings/presentation/widgets/reset_password.dart';
import 'package:money_track/features/settings/presentation/widgets/settings_tile.dart';
import 'package:money_track/features/settings/presentation/widgets/terms_and_condit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const String routename = '/settings-page';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences? prefs;
  String _appVersion = '';

  void _showCustomDialog(BuildContext context, VoidCallback onView) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          icon: Icons.logout,
          submitName: "logout".tr,
          title: 'logout'.tr,
          content: 'are_you_sure'.tr,
          onView: onView,
        );
      },
    );
  }

  void _showPremiumDialog(BuildContext context, VoidCallback onView) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          icon: Icons.info,
          submitName: "ok".tr,
          title: 'cant_proceed'.tr,
          content: 'upgrade_premium'.tr,
          onView: () {},
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) async {
    final selectedLocale = await showDialog<Locale>(
      context: context,
      builder: (BuildContext context) {
        return const LanguageDialog();
      },
    );
    if (selectedLocale != null) {
      Get.updateLocale(selectedLocale);
      String languageCode;
      String countryCode;
      if (selectedLocale == const Locale("en", "US")) {
        languageCode = "en";
        countryCode = "US";
      } else if (selectedLocale == const Locale("mar", "IN")) {
        languageCode = "mar";
        countryCode = "IN";
      } else if (selectedLocale == const Locale("hin", "IN")) {
        languageCode = "hin";
        countryCode = "IN";
      } else {
        return; // Unhandled locale
      }
      prefs?.setStringList('language', [languageCode, countryCode]);
      setState(() {}); // Update the state to reflect the language change
    }
  }

  Future<void> _showCurrencyDialog(BuildContext context) async {
    final selectedCurrency = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const CurrencyDialog();
      },
    );
    if (selectedCurrency != null) {
      setState(() {}); // Refresh to show the updated currency
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return DeleteAllExpensesData();
      },
    );
  }

  Future<void> _showAccountDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("acc_details".tr),
          content: Material(
            child: Container(
              padding: const EdgeInsets.all(
                10,
              ),
              width: deviceSize(context).width *
                  0.8, // Adjust width and height as necessary
              height: deviceSize(context).height * 0.5,
              child: const ProfileDetails(fileName: 'Settings'),
            ),
          ),
        );
      },
    );
  }

  _showPrivacyPolicy(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return const PrivacyPolicy();
        });
  }

  _showTermsandCondiitions(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return const TermsAndConditions();
        });
  }

  _showAboutUs(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return const AboutUs();
        });
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
    _loadAppVersion();
  }

  Future<void> _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {}); // Update the state to reflect the loaded prefs
  }

  Future<void> _loadAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = prefs?.getStringList('language')?[0] ?? 'en';
    String countryCode = prefs?.getStringList('language')?[1] ?? 'US';
    Locale currentLocale = Locale(languageCode, countryCode);

    return ResetPasswordListener(
      child: Scaffold(
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
                padding:
                    EdgeInsets.only(top: deviceSize(context).height * 0.04),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppPallete.whiteColor,
                      ),
                    ),
                    SizedBox(
                      width: deviceSize(context).width * 0.26,
                    ),
                    Text(
                      "settings".tr,
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppPallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'general'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SettingsTile(
                    leadingIcon: Icons.translate,
                    title: 'language'.tr,
                    trailingText: currentLocale.languageCode == 'mar'
                        ? "मराठी"
                        : currentLocale.languageCode == 'hin'
                            ? "हिन्दी"
                            : 'English',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showLanguageDialog(context);
                    },
                  ),
                  SettingsTile(
                    leadingIcon: Icons.notifications,
                    title: 'notifications'.tr,
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showPremiumDialog(context, () {});
                    },
                  ),
                  SettingsTile(
                    leadingIcon: Icons.money,
                    title: 'currency'.tr,
                    trailingText: prefs?.getString('currency') ?? 'rupees'.tr,
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showCurrencyDialog(context);
                    },
                  ),
                  const Divider(),
                  Text(
                    'acc_security'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SettingsTile(
                    leadingIcon: Icons.person,
                    title: 'acc_info'.tr,
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showAccountDialog(context);
                    },
                  ),
                  SettingsTile(
                    leadingIcon: Icons.password,
                    title: 'reset_pass'.tr,
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      showResetPasswordBottomSheet(context);
                    },
                  ),
                  SettingsTile(
                    leadingIcon: Icons.data_array,
                    title: 'data'.tr,
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showDeleteDialog(context);
                    },
                  ),
                  const Divider(),
                  Text(
                    'other'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SettingsTile(
                    leadingIcon: Icons.lock,
                    title: 'privacy_policy'.tr,
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showPrivacyPolicy(context);
                    },
                  ),
                  SettingsTile(
                    leadingIcon: Icons.list_alt,
                    title: 'terms'.tr,
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showTermsandCondiitions(context);
                    },
                  ),
                  SettingsTile(
                    leadingIcon: Icons.group,
                    title: 'about'.tr,
                    trailingText: '',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTrailingIconPressed: () {
                      _showAboutUs(context);
                    },
                  ),
                  const Divider(),
                  SettingsTile(
                    leadingIcon: Icons.app_registration_sharp,
                    title: 'version'.tr,
                    trailingText:
                        _appVersion.isNotEmpty ? _appVersion : 'loading'.tr,
                    trailingIcon: Icons.update,
                    onTrailingIconPressed: () {},
                  ),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "logout".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppPallete.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
