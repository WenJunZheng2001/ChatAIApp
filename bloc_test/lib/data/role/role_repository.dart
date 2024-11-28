import 'package:bloc_test/constants/role_constants.dart';
import 'package:bloc_test/data/auth/auth_service.dart';
import 'package:bloc_test/data/role/role_exceptions.dart';

import '../../model/role_model.dart';
import 'role_data_provider.dart';

class RoleRepository {
  Future<RoleModel> getRoleFromFirebase() async {
    try {
      final role = await RoleProvider().assignRoleFromFirebaseDatabase();
      String? username = AuthService.firebase().currentUser?.username;
      String? email = AuthService.firebase().currentUser?.email;
      final profileIcon = AuthService.firebase().currentUser?.photoUrl;
      String roleIcon = "";
      late int roleMainColor;

      if (username == "") {
        username = "Guest";
      }
      if (email == "") {
        email = "email not found";
      }

      if (role == adminRole) {
        roleIcon = adminRoleIcon;
        roleMainColor = adminRoleMainColor;
      } else if (role == guestRole) {
        roleIcon = guestRoleIcon;
        roleMainColor = guestRoleMainColor;
      }

      RoleModel roleModel = RoleModel(
        username: username ?? "guest",
        role: role,
        roleMainColor: roleMainColor,
        roleProfileIcon: roleIcon,
        email: email ?? "",
        photoUrl: profileIcon,
      );

      return roleModel;
    } catch (_) {
      throw RoleFailedAssignRoleException();
    }
  }
}
