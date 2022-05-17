import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:insuresense/common/my_appbar.dart';
import 'package:insuresense/model/customer.dart';
import 'package:insuresense/model/profile.dart';
import 'package:insuresense/screens/Home_page/home_page.dart';
import 'package:insuresense/screens/Product/products_page.dart';
import 'package:insuresense/screens/Customer/profile_page.dart';

class HomeScreen extends StatefulWidget {
  Customer? user;
  Profile? userProfile;
  HomeScreen({Key? key, @required this.user, @required this.userProfile})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      extendBody: true,
      body: _currentIndex == 1
          ? const HomePage()
          : _currentIndex == 0
              ? const ProductsPage()
              : ProfilePage(
                  user: widget.user,
                  userProfile: widget.userProfile,
                ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0x00ffffff),
        color: Color(0xFF478f75),
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.shopping_bag_rounded, color: Color(0xFF1f303f)),
          Icon(Icons.home, color: Color(0xFF1f303f)),
          Icon(
            Icons.person,
            color: Color(0xFF1f303f),
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
