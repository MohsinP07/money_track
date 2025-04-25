import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
  bool isLoading = false;

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
                  builder: (context) => LoginPage(
                    email: state.user.email,
                  ),
                ),
                (route) => false,
              );
              showSnackBar(context, "acc_created_successfully".tr);
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
                    const SizedBox(height: 80),
                    Text(
                      "sign_up".tr,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CommonTextField(
                      hintText: "email".tr,
                      controller: emailController,
                      leadingIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    CommonTextField(
                      hintText: "name".tr,
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    CommonTextField(
                      hintText: "password".tr,
                      controller: passwordController,
                      isObscureText: true,
                      leadingIcon: Icons.password_outlined,
                    ),
                    const SizedBox(height: 15),
                    isLoading
                        ? Center(
                            child:
                                Lottie.asset("assets/shimmers/mt_loading.json"),
                          )
                        : AuthGradientButton(
                            buttonText: 'sign_up'.tr,
                            onPressed: () {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(AuthSignUp(
                                        email: emailController.text.trim(),
                                        name: nameController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      ));
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              } catch (e) {
                                showSnackBar(context, e.toString());
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginPage.routename);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'already_have_acc'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'sign_in'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppPallete.boxColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
