import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';

void showResetPasswordBottomSheet(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return ResetPasswordBottomSheet(
        emailController: emailController,
        passwordController: passwordController,
      );
    },
  );
}

class ResetPasswordBottomSheet extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const ResetPasswordBottomSheet({
    required this.emailController,
    required this.passwordController,
    Key? key,
  }) : super(key: key);

  @override
  _ResetPasswordBottomSheetState createState() =>
      _ResetPasswordBottomSheetState();
}

class _ResetPasswordBottomSheetState extends State<ResetPasswordBottomSheet> {
  bool showWarningText = false;

  void onResetPressed() {
    final String email = widget.emailController.text.trim();
    final String newPassword = widget.passwordController.text.trim();

    if (email.isNotEmpty && newPassword.isNotEmpty) {
      context.read<AuthBloc>().add(
            AuthResetPassword(
              email: email,
              newPassword: newPassword,
            ),
          );
      Navigator.of(context).pop(); // Close the bottom sheet
    } else {
      setState(() {
        showWarningText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reset Password",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.passwordController,
              decoration: const InputDecoration(
                labelText: "New Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (showWarningText)
              const Text(
                'Please fill all the fields',
                style: TextStyle(color: Colors.red),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppPallete.errorColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: deviceSize(context).width * 0.34,
                  child: CustomButton(text: "Reset", onTap: onResetPressed),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordListener extends StatelessWidget {
  final Widget child;

  const ResetPasswordListener({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSuccess) {
          showSnackBar(context, 'Password reset successfully');
          context.read<AuthBloc>().add(AuthLogout(context: context));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
          showSnackBar(context, 'Please log inn!');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: child,
    );
  }
}
