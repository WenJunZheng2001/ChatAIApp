import 'package:bloc_test/model/role_model.dart';

abstract class RoleState {}

class RoleInitialState extends RoleState {}

class RoleAssignRoleSuccessState extends RoleState {
  final RoleModel roleModel;

  RoleAssignRoleSuccessState({required this.roleModel});
}

class RoleAssignRoleFailedState extends RoleState {}

class RoleErrorState extends RoleState {}

class RoleLoadingState extends RoleState {}
