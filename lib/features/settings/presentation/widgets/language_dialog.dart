import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  SharedPreferences? prefs;

  final List locale = [
    {"name": "English", "locale": const Locale("en", "US")},
    {"name": "मराठी", "locale": const Locale("mar", "IN")},
    {"name": "हिन्दी", "locale": const Locale("hin", "IN")},
  ];

  dynamic selectedLocale;

  void updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
    String languageCode;
    String countryCode;
    if (locale == const Locale("en", "US")) {
      languageCode = "en";
      countryCode = "US";
    } else if (locale == const Locale("mar", "IN")) {
      languageCode = "mar";
      countryCode = "IN";
    } else if (locale == const Locale("hin", "IN")) {
      languageCode = "hin";
      countryCode = "IN";
    } else {
      return; // Unhandled locale
    }
    prefs?.setStringList('language', [languageCode, countryCode]);
    setState(() {}); // Update the state to reflect the language change
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // Fetch the currently selected language from SharedPreferences
    String languageCode = prefs?.getStringList('language')?[0] ?? 'en';
    String countryCode = prefs?.getStringList('language')?[1] ?? 'US';
    Locale currentLocale = Locale(languageCode, countryCode);

    // Find the corresponding locale object in the list
    var initialSelectedLocale = locale.firstWhere(
      (element) => element['locale'] == currentLocale,
      orElse: () => null,
    );

    // Set initial selected locale
    setState(() {
      selectedLocale = initialSelectedLocale?['locale'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      content: Container(
        height: deviceSize(context).height * 0.38,
        width: deviceSize(context).width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(
                      locale[index]["name"],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: locale[index]["locale"],
                    groupValue: selectedLocale,
                    onChanged: (value) {
                      setState(() {
                        selectedLocale = value;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.blue,
                  );
                },
                itemCount: locale.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedLocale != null)
                  SizedBox(
                    width: deviceSize(context).width * 0.26,
                    child: CustomButton(
                      text: 'Submit',
                      onTap: () {
                        updateLanguage(selectedLocale);
                      },
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
