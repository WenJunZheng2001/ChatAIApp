import 'package:bloc_test/bloc/auth_bloc/auth_bloc.dart';
import 'package:bloc_test/bloc/auth_bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_state.dart';
import '../utility/input_text_field.dart';
import '../utility/my_button.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  late TextEditingController _emailController;

  @override
  initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  dispose() {
    _emailController.dispose();
    super.dispose();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
      String text) {
    if (mounted) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(surfaceTintColor: Colors.transparent),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Reset your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    title: 'Email',
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSentPasswordResetSuccessState) {
                        showSnackBar(
                            "Ti abbiamo mandato un email di verifica.");
                      }
                      if (state is AuthFailedSendResetPasswordState) {
                        showSnackBar(state.error);
                      }
                    },
                    child: MyButton(
                      onTap: () {
                        final email = _emailController.text.trim();
                        context
                            .read<AuthBloc>()
                            .add(AuthResetPasswordEvent(email: email));
                      },
                      text: 'Reset Password',
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Back to",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Log in",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
