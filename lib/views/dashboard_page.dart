

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/providers/common_provider.dart';
import 'package:simple_shop/views/dashboards/create_page.dart';
import 'package:simple_shop/views/dashboards/crud_page.dart';
import 'package:simple_shop/views/dashboards/home_page.dart';
import 'package:simple_shop/views/dashboards/profile_page.dart';

class DashBoardPage extends ConsumerWidget {
  final List<Widget> _pages = [
    const HomePage(),
    CreatePage(),
    const CrudPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, ref) {
    final index = ref.watch(indexProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[index],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: blue,
          currentIndex: index,
          onTap: (index) {
            ref.read(indexProvider.notifier).change(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: 'Customize'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
