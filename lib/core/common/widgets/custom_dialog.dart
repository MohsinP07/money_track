import 'package:flutter/material.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class CustomDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String submitName;
  final String content;
  final VoidCallback onView;

  CustomDialog({
    required this.icon,
    required this.title,
    required this.submitName,
    required this.content,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 66.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: const EdgeInsets.only(top: 55.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppPallete.errorColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onView();
                      },
                      child: Text(
                        submitName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppPallete.buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: AppPallete.borderColor,
            radius: 50.0,
            child: Icon(
              icon,
              size: 60.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
