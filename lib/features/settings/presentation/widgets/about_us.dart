import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text('about'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('about_me'.tr),
              const SizedBox(height: 8),
              _buildSectionContent('ab1'.tr),
              const SizedBox(height: 16),
              _buildSectionTitle('yoe'.tr),
              const SizedBox(height: 8),
              _buildSectionContent('yoe2'.tr),
              const SizedBox(height: 16),
              _buildSectionTitle('contact_details'.tr),
              const SizedBox(height: 8),
              _buildSectionContent('Email: global.mohsinpatel786@gmail.com'),
              const SizedBox(height: 16),
              _buildSectionTitle('social'.tr),
              const SizedBox(height: 8),
              _buildSocialMediaIcons(context),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'close'.tr,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget _buildSocialMediaIcons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(const ClipboardData(
                    text:
                        'https://www.linkedin.com/in/mohsin-patel-1874621a2/'))
                .then((value) => showSnackBar(context, 'link_copired'.tr));
          },
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/images/linkedin.png',
                  fit: BoxFit.cover,
                  width: 24,
                  height: 24,
                ),
                onPressed: () {},
              ),
              Text(
                'profile_link'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Icon(Icons.copy)
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(
                    const ClipboardData(text: 'https://github.com/MohsinP07'))
                .then((value) => showSnackBar(context, 'link_copired'.tr));
          },
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/images/git.png',
                  fit: BoxFit.cover,
                  width: 24,
                  height: 24,
                ),
                onPressed: () {},
              ),
              Text(
                'profile_link'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Icon(Icons.copy)
            ],
          ),
        ),
      ],
    );
  }
}
