import 'package:base/common/common.dart';
import 'package:flutter/material.dart';
import 'w_menu_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const MenuDrawer(),
      body: Container(
        color: context.appColors.badgeBorder.getMaterialColorValues[200],
        child: const SafeArea(
          child: Placeholder(),
        ),
      ),
    );
  }

}
