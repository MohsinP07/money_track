import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('About Us', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('About Me'),
              const SizedBox(height: 8),
              _buildSectionContent(
                  'As a seasoned full-stack developer with a specialization in Android, I bring three years of hands-on experience in crafting innovative and efficient Android applications. My expertise extends beyond mere app development, encompassing the creation of robust websites from scratch. I also have good work experience in developing apps with clean code architecture. I am dedicated to delivering solutions tailored to your unique requirements, ensuring that your apps not only meet but exceed expectations. With a passion for staying at the forefront of technology, I am committed to providing cutting-edge and scalable solutions for a seamless user experience. Let\'s collaborate to turn your ideas into reality.'),
              const SizedBox(height: 16),
              _buildSectionTitle('Years of Experience'),
              const SizedBox(height: 8),
              _buildSectionContent('Years of Experience: 3'),
              const SizedBox(height: 16),
              _buildSectionTitle('Contact Details'),
              const SizedBox(height: 8),
              _buildSectionContent('Email: global.mohsinpatel786@gmail.com'),
              const SizedBox(height: 16),
              _buildSectionTitle('Social Media'),
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
          child: const Text(
            'Close',
            style: TextStyle(
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
                .then((value) =>
                    showSnackBar(context, 'Link copied successfully'));
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
              const Text(
                'Copy Profile Link ',
                style: TextStyle(
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
                .then((value) =>
                    showSnackBar(context, 'Link copied successfully'));
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
              const Text(
                'Copy Profile Link ',
                style: TextStyle(
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
