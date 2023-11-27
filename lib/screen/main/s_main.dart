import 'dart:convert';

import 'package:base/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:web_socket_channel/io.dart';
import 'w_menu_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  /// Binance Websocket
  late final channel = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws/btcusdt@trade');

  late final Stream<dynamic> stream;
  String text = 'Loading...';
  final List<double> priceList = [];

  @override
  void initState() {
    stream = channel.stream;
    stream.listen((event) {
      final obj = json.decode(event);
      final double price = double.parse(obj['p']);
      setState(() {
        priceList.add(price);
        text = price.toString();
      });
    });
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
