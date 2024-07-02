import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const String routename = '/settings-page';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text(
              'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
