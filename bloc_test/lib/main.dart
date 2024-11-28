import 'dart:async';

import 'package:bloc_test/screen/auth_page.dart';
import 'package:bloc_test/screen/role_control_page.dart';
import 'package:bloc_test/data/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/chat_bloc/chat_bloc.dart';
import 'bloc/mic_cubit/mic_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  await dotenv.load(fileName: "assets/.env");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
        BlocProvider<MicCubit>(create: (context) => MicCubit()..initServices()),
      ],
      child: GlobalLoaderOverlay(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const MainPage(),
        ),
      ),
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Qualcosa è andato storto."),
          );
        }
        if (snapshot.hasData) {
          context.loaderOverlay.hide();
          final providerData = snapshot.data?.providerData;

          if ((snapshot.data?.emailVerified ?? false) ||
              (snapshot.data?.isAnonymous ?? false)) {
            return const RolePage();
          }
          if (providerData != [] &&
              providerData?[0].providerId == "google.com") {
            return const RolePage();
          }
        }
        return const AuthPage();
      },
    );
  }
}
