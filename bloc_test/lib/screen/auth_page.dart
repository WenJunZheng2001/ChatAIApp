import 'package:bloc_test/bloc/auth_bloc/auth_bloc.dart';
import 'package:bloc_test/bloc/auth_bloc/auth_state.dart';
import 'package:bloc_test/constants/image_constants.dart';
import 'package:bloc_test/screen/login_page.dart';
import 'package:bloc_test/screen/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  late Image appleIconLogo;
  late Image appleIconLogoWhite;
  late Image googleIconLogo;

  @override
  initState() {
    super.initState();
    appleIconLogo = Image.asset(appleIcon);
    appleIconLogoWhite = Image.asset(appleWhiteIcon);
    googleIconLogo = Image.asset(googleIcon);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(appleIconLogo.image, context);
    precacheImage(appleIconLogoWhite.image, context);
    precacheImage(googleIconLogo.image, context);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
      String text, int durationSeconds) {
    if (mounted) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          duration: Duration(seconds: durationSeconds),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      child: isLogin
          ? LoginPage(onClickedSignUp: toggle)
          : RegisterPage(onClickedSignIn: toggle),
      listener: (context, state) {
        if (state is AuthLoadingState) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
        if (state is AuthLoginSuccessState) {}
        if (state is AuthErrorState) {
          showSnackBar(state.error, 2);
        }
        if (state is AuthGenericFailState) {
          showSnackBar(state.error, 1);
        }
        if (state is AuthRegistrationSuccessState) {
          showSnackBar("Ti abbiamo inviato un email di verifica", 3);
          toggle();
        }
        if (state is AuthEmailInvalidState) {
          showSnackBar("Invalid Email", 2);
        }
      },
    );
  }

  void toggle() => setState(() => isLogin = !isLogin);
}
