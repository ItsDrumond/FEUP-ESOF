import 'package:findit_app/pages/applied_page.dart';
import 'package:findit_app/pages/favorites_page.dart';
import 'package:findit_app/pages/logout_page.dart';
import 'package:findit_app/pages/profile_page.dart';
import 'package:findit_app/pages/search_page.dart';
import 'package:findit_app/utils/screen_config.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScreenConfig screen = ScreenConfig();

  int currentPage = 1;
  List<Widget> pages = const [
    ProfilePage(),
    SearchPage(),
    FavoritesPage(),
    AppliedPage(),
    LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    screen.init(context);
    return Scaffold(
      body: Center(
          child: pages[currentPage],
      ),
      bottomNavigationBar: SizedBox(
        height: screen.blockSizeVertical * 11.4,
        child: BottomNavigationBarTheme(
          data: const BottomNavigationBarThemeData(
            elevation: 0,
            selectedIconTheme: IconThemeData(
            ),
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromRGBO(55, 8, 12, 1),
            backgroundColor: Color.fromARGB(255, 157, 121, 123),
          ),
          child: BottomNavigationBar(
            currentIndex: currentPage,
            onTap: (int newPage) {
              setState(() {
                currentPage = newPage;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  size: 40,
                  ),
                label: 'Profile'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 40,
                  ),
                label: 'Search'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.star,
                  size: 40,
                ),
                label: 'Favorites'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_box,
                  size: 40,
                  ),
                label: 'Applied'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.logout,
                  size: 40,
                  ),
                label: 'Logout'
              ),
            ],
          ),
        ),
      )
    );
  }
}