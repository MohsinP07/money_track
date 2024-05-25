import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/features/auth/presentation/widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  static const String routename = '/signup-page';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
                          builder: (context) => const LoginPage()),
                      (route) => false);
                  showSnackBar(context, 'Account Created!');
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
                          height: 80,
                        ),
                        const Text(
                          "Sign Up.",
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
                          hintText: "Name",
                          controller: nameController,
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
                            buttonText: 'Sign Up',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(AuthSignUp(
                                      email: emailController.text.trim(),
                                      name: nameController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ));
                                print(emailController.text.trim());
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginPage.routename);
                          },
                          child: RichText(
                            text: TextSpan(
                                text: 'Already have account? ',
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: 'Sign In.',
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
