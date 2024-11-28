import 'package:bloc_test/bloc/auth_bloc/auth_event.dart';
import 'package:bloc_test/bloc/mic_cubit/mic_cubit.dart';
import 'package:bloc_test/constants/image_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../utility/role_button.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String role;
  final String roleProfileIcon;
  final int roleMainColor;
  final String email;
  final String? photoUrl;

  const ProfilePage(
      {super.key,
      required this.username,
      required this.role,
      required this.roleProfileIcon,
      required this.roleMainColor,
      required this.email,
      required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Profile",
          ),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Basic details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Update your personal information.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                "Profile picture",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: photoUrl != null
                        ? CachedNetworkImageProvider(photoUrl ?? "")
                        : Image.asset(roleProfileIcon).image,
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  const Text("Role:"),
                  const SizedBox(
                    width: 10,
                  ),
                  RoleButton(text: role, color: Color(roleMainColor)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Username: $username"),
              Text("Email: $email"),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () =>
                      context.read<AuthBloc>().add(AuthDeleteAccountEvent()),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF8952E0)),
                  ),
                  child: const Text(
                    "Delete account forever",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 50),
              Center(
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLogoutSuccessState ||
                        state is AuthSuccessDeletedAccountState) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: GestureDetector(
                    onTap: () async {
                      await context.read<MicCubit>().closePage();
                      if (context.mounted) {
                        context.read<AuthBloc>().add(AuthSignOutEvent());
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2140A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              bulletPointWhiteIcon,
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Log out",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              bulletPointWhiteIcon,
                              width: 14,
                              height: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
