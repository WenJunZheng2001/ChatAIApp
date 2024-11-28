import 'package:bloc_test/constants/image_constants.dart';
import 'package:bloc_test/constants/role_constants.dart';
import 'package:bloc_test/utility/drawer_utility/role_management.dart';
import 'package:bloc_test/utility/drawer_utility/toggle_switch_premium.dart';
import 'package:bloc_test/utility/drawer_utility/toogle_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../model/dropdown_item_model.dart';
import '../../model/icon_model.dart';
import '../role_button.dart';
import 'menu_dropdown.dart';

class DrawerManagement extends StatefulWidget {
  final String username;
  final String role;
  final int roleMainColor;
  final String roleProfileIcon;
  final String email;
  final String? photoUrl;
  final Function() toggleDrawer;

  const DrawerManagement({
    super.key,
    required this.username,
    required this.role,
    required this.roleMainColor,
    required this.roleProfileIcon,
    required this.email,
    required this.photoUrl,
    required this.toggleDrawer,
  });

  @override
  State<DrawerManagement> createState() => _DrawerManagementState();
}

class _DrawerManagementState extends State<DrawerManagement> {
  var listaNomiEIcone = [
    [yatchIcon, "Yatch"],
    [restaurantIcon, "Restaurant"],
    [infoButtonIcon, "Info"],
  ];

  var listaCategorie = [
    IconClass(
        icon: Icons.folder,
        categoria: 'Organization',
        icon2: Icons.settings,
        childCategoria: 'Overview'),
    IconClass(
        icon: Icons.tag,
        categoria: 'Tag',
        icon2: Icons.developer_board,
        childCategoria: 'Developer'),
  ];

  @override
  Widget build(BuildContext context) {
    return drawerNavigator(context);
  }

  Widget drawerNavigator(BuildContext context) => Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildMenuItems(context),
                  ],
                ),
              ),
            ),
            widget.role == adminRole
                ? const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CrazySwitchPremium(
                        text1: 'Audio personalizzato attivo',
                        text2: 'Audio personalizzato disativato',
                      ),
                    ),
                  )
                : const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Diventa admin per ricevere\naudio personalizzato"),
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CrazySwitch(
                text1: 'Ascolto mic attivato',
                text2: 'Ascolto mic disattivato',
              ),
            ),
          ],
        ),
      );

  Widget buildHeader(BuildContext context) => InkWell(
        onTap: () async {
          widget.toggleDrawer();
          // await Future.delayed(const Duration(milliseconds: 400), () {
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => ProfilePage(
          //       username: widget.username,
          //       role: widget.role,
          //       roleProfileIcon: widget.roleProfileIcon,
          //       roleMainColor: widget.roleMainColor,
          //       email: widget.email,
          //       photoUrl: widget.photoUrl,
          //     ),
          //   ));
          // });
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? bulletPointWhiteIcon
                      : bulletPointIcon,
                  width: 14,
                  height: 14,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    widget.username,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                RoleButton(
                    text: widget.role, color: Color(widget.roleMainColor)),
                const SizedBox(
                  width: 8,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: widget.photoUrl != null
                          ? CachedNetworkImageProvider(widget.photoUrl ?? "")
                              as ImageProvider
                          : AssetImage(widget.roleProfileIcon),
                      backgroundColor: Colors.transparent,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        child: Wrap(
          children: [
            const Divider(),
            for (List<String> tab in listaNomiEIcone)
              TabCategory(
                imagePath: tab[0],
                categoria: tab[1],
              ),
            CustomDropdownMenu(
              icon: Icons.folder,
              label: 'Organization',
              dropdownItems: [
                DropdownItem(
                  icon: Icons.settings,
                  label: 'Overview',
                  onTap: () {
                    // Azione da eseguire quando si tocca "Overview"
                  },
                ),
                DropdownItem(
                  icon: Icons.people,
                  label: 'Members',
                  onTap: () {
                    // Azione da eseguire quando si tocca "Members"
                  },
                ),
                DropdownItem(
                  icon: Icons.description,
                  label: 'Plans',
                  onTap: () {
                    // Azione da eseguire quando si tocca "Plans"
                  },
                ),
                DropdownItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Billing',
                  onTap: () {
                    // Azione da eseguire quando si tocca "Billing"
                  },
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      );
}
