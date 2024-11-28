import 'package:bloc_test/utility/drawer_utility/drawer_management.dart';
import 'package:bloc_test/screen/user_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_bloc/chat_event.dart';

import '../constants/image_constants.dart';
import '../utility/microphone_utility/mic_button_series.dart';
import 'microphone_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String role;
  final int roleMainColor;
  final String roleProfileIcon;
  final String email;
  final String? photoUrl;

  const HomePage(
      {super.key,
      required this.username,
      required this.role,
      required this.roleMainColor,
      required this.roleProfileIcon,
      required this.email,
      required this.photoUrl});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late bool _isExpanded = false;
  late AnimationController myAnimation;
  late ChatBloc chatBloc;
  late CachedNetworkImageProvider imageProfile;
  late Image botIcon;
  late Image userDefaultIcon;
  late Image botAnimatedIcon;
  late Image profileIcon;

  @override
  void initState() {
    super.initState();
    myAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.photoUrl != null) {
      imageProfile = CachedNetworkImageProvider(widget.photoUrl ?? "");
    }
    userDefaultIcon = Image.asset(
      userImageIcon,
      gaplessPlayback: true,
    );
    botIcon = Image.asset(
      chatBotIcon,
      gaplessPlayback: true,
      fit: BoxFit.cover,
    );
    botAnimatedIcon = Image.asset(
      botFixedIcon,
      gaplessPlayback: true,
      fit: BoxFit.cover,
    );
    profileIcon = Image.asset(widget.roleProfileIcon);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatBloc = context.read<ChatBloc>();
    if (widget.photoUrl != null) {
      precacheImage(imageProfile, context);
    }
    precacheImage(userDefaultIcon.image, context);
    precacheImage(botIcon.image, context);
    precacheImage(botAnimatedIcon.image, context);
    precacheImage(profileIcon.image, context);
  }

  @override
  void dispose() {
    myAnimation.dispose();
    chatBloc.add(ChatCloseDatabaseEvent());
    super.dispose();
  }

  toggleDrawer() async {
    if (!_isExpanded) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      _scaffoldKey.currentState?.openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "Home",
        ),
        centerTitle: true,
        leading: IconButton(
          tooltip: "Menu",
          splashColor: Colors.transparent,
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: myAnimation,
          ),
          onPressed: toggleDrawer,
        ),
        actions: [
          IconButton(
            tooltip: "Profile",
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(
                  username: widget.username,
                  role: widget.role,
                  roleProfileIcon: widget.roleProfileIcon,
                  roleMainColor: widget.roleMainColor,
                  email: widget.email,
                  photoUrl: widget.photoUrl,
                ),
              ));
            },
            icon: const Icon(
              Icons.account_circle,
            ),
          ),
        ],
      ),
      body: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerManagement(
          username: widget.username,
          role: widget.role,
          roleMainColor: widget.roleMainColor,
          roleProfileIcon: widget.roleProfileIcon,
          email: widget.email,
          photoUrl: widget.photoUrl,
          toggleDrawer: toggleDrawer,
        ),
        drawerEnableOpenDragGesture: true,
        drawerScrimColor: Colors.grey.withOpacity(0.6),
        onDrawerChanged: (isOpened) {
          _isExpanded = !_isExpanded;
          isOpened ? myAnimation.forward() : myAnimation.reverse();
        },
        body: MicrophoneContent(
          photoUrl: widget.photoUrl,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MicButtonSeries(photoUrl: widget.photoUrl),
      ),
    );
  }
}
