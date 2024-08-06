import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ddudu/provider/store.dart';

const double borderRadius = 25.0;

class TopTabBar extends StatefulWidget {
  const TopTabBar({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<TopTabBar> createState() => _TopTabBarState();
}

class _TopTabBarState extends State<TopTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0XFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onPlaceBidButtonPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (context.watch<Store>().topCurrTab == 0) ? const BoxDecoration(
                  color: Color(0xff5a95ff),
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ) : null,
                child: Text(
                  "Monthly",
                  style: (context.watch<Store>().topCurrTab == 0) ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onBuyNowButtonPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (context.watch<Store>().topCurrTab == 1) ? const BoxDecoration(
                  color: Color(0xff5a95ff),
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ) : null,
                child: Text(
                  "Daily",
                  style: (context.watch<Store>().topCurrTab == 1) ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) : const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPlaceBidButtonPress() {
    widget.pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onBuyNowButtonPress() {
    widget.pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
