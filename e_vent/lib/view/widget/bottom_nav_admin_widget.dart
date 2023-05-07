import 'package:e_vent/view/admin/screen/event_add_screen.dart';
import 'package:e_vent/view/profile/screen/profile_screen.dart';
import 'package:e_vent/view/admin/screen/home_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Admin extends StatefulWidget {
  final String id;
  const Admin({super.key, required this.id});
  @override
  State<Admin> createState() => _AdminState(id: id);
}

class _AdminState extends State<Admin> {
  String id;
  DateTime preBackPress = DateTime.now();

  _AdminState({required this.id});

  PageController pageController = PageController();
  List<Widget> pages = [
    const HomeAdminScreen(),
    const EventAddScreen(),
    const Profile()
  ];
  int _selectedIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onItemTap(int selectedItems) {
    pageController.jumpToPage(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timeGap = DateTime.now().difference(preBackPress);

        final cantExit = timeGap >= const Duration(seconds: 2);
        preBackPress = DateTime.now();
        if (cantExit) {
          const snack = SnackBar(
            content: Text('Press Back Button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: pages[_selectedIndex],

        // you can use the molten bar in the scaffold's bottomNavigationBar
        bottomNavigationBar: Container(
          color: const Color(0xffF1511B),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: GNav(
              color: Colors.white60,
              activeColor: const Color(0xffF1511B),
              tabBackgroundColor: Colors.white,
              tabBorderRadius: 15,
              hoverColor: Colors.grey,
              selectedIndex: _selectedIndex,
              padding: const EdgeInsets.all(10),
              gap: 8,
              // specify what will happen when a tab is clicked
              onTabChange: (clickedIndex) {
                setState(() {
                  _selectedIndex = clickedIndex;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.add,
                  text: 'Add Event',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
