import 'package:flutter/material.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class GoalBox extends StatelessWidget {
  const GoalBox({
    super.key,
    required this.deviceSize,
    required this.image,
    required this.title,
    required this.onPressed,
  });

  final Size deviceSize;
  final String image;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 7,
      borderRadius: BorderRadius.circular(24),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        splashColor: AppPallete.borderColor.withOpacity(0.08),
        highlightColor: AppPallete.borderColor.withOpacity(0.05),
        child: Container(
          width: deviceSize.width * 0.42,
          height: deviceSize.height * 0.25,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            border: Border.all(color: AppPallete.borderColor.withOpacity(0.27)),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppPallete.borderColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                margin: const EdgeInsets.only(bottom: 10 ,top: 10),
                decoration: BoxDecoration(
                  color: AppPallete.borderColor.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Image.asset(
                    image,
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: CustomButton(
                  text: "Create",
                  onTap: onPressed,
                  borderRadius: 16,
                  fontSize: 15,
                  height: 38,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
