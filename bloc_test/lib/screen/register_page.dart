import 'package:bloc_test/bloc/auth_bloc/auth_event.dart';
import 'package:bloc_test/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../utility/input_text_field.dart';
import '../utility/my_button.dart';
import '../utility/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function() onClickedSignIn;
  const RegisterPage({super.key, required this.onClickedSignIn});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool isLogging = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(surfaceTintColor: Colors.transparent)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: () =>
                        context.read<AuthBloc>().add(AuthGoogleLoginEvent()),
                    imagePath: googleIcon,
                    text: 'Continue with',
                    text2: 'Google',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SquareTile(
                    imagePath: Theme.of(context).brightness == Brightness.dark
                        ? appleWhiteIcon
                        : appleIcon,
                    text: 'Continue with',
                    text2: 'Apple',
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(),
              const SizedBox(
                height: 25,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      title: 'Email',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      title: 'Password',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm password',
                      obscureText: true,
                      title: 'Password',
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    MyButton(
                      onTap: () => context
                          .read<AuthBloc>()
                          .add(AuthRequestRegistrationEvent(
                            email: emailController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                          )),
                      text: 'Sign in',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: widget.onClickedSignIn,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Log in now!",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
