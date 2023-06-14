import 'package:dbestblog/pages/home/home_page.dart';
import 'package:dbestblog/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';

var bottovNavBarTabs = [
  const NavigationDestination(
    selectedIcon: Icon(Icons.home),
    icon: Icon(Icons.home_outlined),
    label: 'Home',
  ),
  const NavigationDestination(
    selectedIcon: Icon(Icons.add),
    icon: Icon(Icons.add_outlined),
    label: 'New post',
  ),
  const NavigationDestination(
    selectedIcon: Icon(Icons.person),
    icon: Icon(Icons.person_outline),
    label: 'Profile',
  ),
];

Widget buildPage(int index) {
  List<Widget> _widgets = [
    const HomePage(),
    const Center(
      child: Text('add post'),
    ),
    const ProfilePage(),
  ];

  return _widgets[index];
}
