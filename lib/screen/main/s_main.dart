import 'dart:convert';

import 'package:base/common/common.dart';
import 'package:base/common/dart/extension/num_duration_extension.dart';
import 'package:base/common/widget/AnimatedNumberText.dart';
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
  late final channel = IOWebSocketChannel.connect(
      'wss://stream.binance.com:9443/ws/btcusdt@trade');

  late final Stream<dynamic> stream;
  String priceString = 'Loading...';
  final List<double> priceList = [];

  final intervalDuration = 1.seconds;
  DateTime lastUpdatedTime = DateTime.now();

  @override
  void initState() {
    stream = channel.stream;
    stream.listen((event) {
      final obj = json.decode(event);
      final double price = double.parse(obj['p']);
      if(DateTime.now().difference(lastUpdatedTime) > intervalDuration) {
        lastUpdatedTime = DateTime.now();
        setState(() {
          priceList.add(price);
          // toDoubleStringAsFixed()=> 소수점 두자리수로 끊어줌
          priceString = price.toDoubleStringAsFixed();
        });
      }

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      body: Container(
        child: SafeArea(
          child: Center(
            child: AnimatedNumberText(
              priceString,
              textStyle: const TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
                duration: 50.ms,
            ),
          ),
        ),
      ),
    );
  }
}
