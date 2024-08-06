import 'package:ddudu/provider/store.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 22,
      currentIndex : context.watch<Store>().bottomNavCurrTab,
      onTap: (i){
        context.read<Store>().chgBottomTabNum(i);
      },
      items: const [
        BottomNavigationBarItem(
          label: '메뉴',
          icon: FaIcon(FontAwesomeIcons.rectangleList),
          activeIcon: FaIcon(FontAwesomeIcons.solidRectangleList),
        ),
        BottomNavigationBarItem(
          label: '예약',
          icon: FaIcon(FontAwesomeIcons.clock),
          activeIcon: FaIcon(FontAwesomeIcons.solidClock),
        ),
        BottomNavigationBarItem(
          label: '알림',
          icon: FaIcon(FontAwesomeIcons.bell),
          activeIcon: FaIcon(FontAwesomeIcons.solidBell),
        ),
        BottomNavigationBarItem(
          label: '마이페이지',
          icon: FaIcon(FontAwesomeIcons.user),
          activeIcon: FaIcon(FontAwesomeIcons.solidUser),
        ),
      ],
    );
  }
}
