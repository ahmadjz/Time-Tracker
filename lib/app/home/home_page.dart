import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:time_tracker/app/home/account/account_page.dart';
import 'package:time_tracker/app/home/entries/entries_page.dart';
import 'package:time_tracker/app/home/jobs/jobs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.menuScreenContext});
  final BuildContext menuScreenContext;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  List<Widget> _buildScreens() => [
        const JobsPage(),
        EntriesPage.create(context),
        const AccountPage(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.directions_run),
          title: "Jobs",
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shop),
          title: "Entries",
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Account",
          inactiveColorPrimary: Colors.grey,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        resizeToAvoidBottomInset: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        bottomScreenMargin: 0,
        backgroundColor: Colors.white,
        hideNavigationBar: false,
        decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
        ),
        navBarStyle:
            NavBarStyle.style6, // Choose the nav bar style with this property
      ),
    );
  }
}
