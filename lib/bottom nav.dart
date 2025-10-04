import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/Teaching.dart';
import 'package:my_app/subsidy.dart';
import 'package:my_app/values.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'Log.dart';
import 'home.dart';
import 'main advice.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selected = 0;
  final controller = PageController();

  final pages = [
    Home(),
    Log(),
    MainAdvice(),
    Teaching(),
    Subsidy(),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      bottomNavigationBar: StylishBottomBar(
        option:  AnimatedBarOptions(iconStyle: IconStyle.animated),
        backgroundColor: Colors.white70,
        items: [
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.house),
            selectedColor: themeColor,
            unSelectedColor: Colors.grey,
            title: Text('Home'),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.listCheck),
            selectedColor: themeColor,
            title: Text('DailyLog'),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.handHoldingHeart),
            selectedColor: themeColor,
            title: Text('Advice'),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.book),
            selectedColor: themeColor,
            title: Text('Teaching'),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.coins),
            selectedColor: themeColor,
            title: Text('Subsidy'),
          ),
        ],
        hasNotch: true,
        currentIndex: selected,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() => selected = index);
        },
      ),

      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(), // lock swipe if you want
          onPageChanged: (i) => setState(() => selected = i),
          children: pages,
        ),
      ),
    );
  }
}