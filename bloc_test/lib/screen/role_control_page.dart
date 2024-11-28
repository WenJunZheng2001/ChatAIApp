import 'package:bloc_test/bloc/role_bloc/role.state.dart';
import 'package:bloc_test/bloc/role_bloc/role_bloc.dart';
import 'package:bloc_test/bloc/role_bloc/role_event.dart';
import 'package:bloc_test/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String text, int durationSeconds) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoleBloc>(
            create: (BuildContext context) =>
                RoleBloc()..add(RoleAssignRoleEvent())),
      ],
      child: BlocConsumer<RoleBloc, RoleState>(
        listener: (context, state) {
          if (state is RoleAssignRoleFailedState) {
            showSnackBar(context, "ruolo fail", 2);
          }
          if (state is RoleAssignRoleSuccessState) {
            // final role = state.roleModel.role;
            // showSnackBar(context, "Benvenuto $role", 2);
          }
        },
        builder: (context, state) {
          if (state is RoleAssignRoleSuccessState) {
            final roleModel = state.roleModel;
            return HomePage(
              role: roleModel.role,
              roleProfileIcon: roleModel.roleProfileIcon,
              username: roleModel.username,
              roleMainColor: roleModel.roleMainColor,
              email: roleModel.email,
              photoUrl: roleModel.photoUrl,
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
