import 'package:bloc_test/constants/image_constants.dart';
import 'package:bloc_test/screen/password_recovery_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../utility/input_text_field.dart';
import '../utility/my_button.dart';
import '../utility/square_tile.dart';

class LoginPage extends StatefulWidget {
  final Function() onClickedSignUp;

  const LoginPage({super.key, required this.onClickedSignUp});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLogging = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                "Welcome back",
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
                      hintText: "Email",
                      obscureText: false,
                      title: 'Email',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                      controller: passwordController,
                      obscureText: true,
                      hintText: 'Password',
                      title: 'Password',
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordResetScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Colors.blue[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyButton(
                      onTap: () => context.read<AuthBloc>().add(
                          AuthRequestLoginEvent(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim())),
                      text: 'Log in',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(AuthAnonymousLoginEvent());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter as a",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "guest",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: widget.onClickedSignUp,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No account yet?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Sign up",
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
