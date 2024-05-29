import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/auth/presentation/pages/signup_page.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';

class LoginPage extends StatefulWidget {
  static const String routename = '/login-page';
  final String? email;
  const LoginPage({super.key, this.email});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackBar(context, state.message);
                } else if (state is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BottomBar(initialPage: 0)),
                      (route) => false);
                  // showSnackBar(context, "Logged In!!");
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                }
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        const Text(
                          "Sign In.",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CommonTextField(
                          hintText: "Email",
                          controller: emailController,
                          leadingIcon: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CommonTextField(
                          hintText: "Password",
                          controller: passwordController,
                          isObscureText: true,
                          leadingIcon: Icons.password_outlined,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AuthGradientButton(
                            buttonText: 'Sign In.',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(AuthLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()));
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpPage.routename);
                          },
                          child: RichText(
                            text: TextSpan(
                                text: 'Don\'t have account? ',
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: 'Sign Up.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppPallete.gradient2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));
  }
}
