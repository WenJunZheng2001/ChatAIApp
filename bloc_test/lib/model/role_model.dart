class RoleModel {
  final String username;
  final String role;
  final int roleMainColor;
  final String roleProfileIcon;
  final String email;
  final String? photoUrl;

  RoleModel({
    required this.username,
    required this.role,
    required this.roleMainColor,
    required this.roleProfileIcon,
    required this.email,
    required this.photoUrl,
  });
}
