import 'dart:convert';
import 'dart:math';

import 'package:base/common/common.dart';
import 'package:base/common/dart/extension/num_duration_extension.dart';
import 'package:base/common/widget/AnimatedNumberText.dart';
import 'package:flutter/material.dart';
import 'package:live_background/live_background.dart';
import 'package:live_background/object/particle_shape_type.dart';
import 'package:live_background/widget/live_background_widget.dart';
import 'package:web_socket_channel/io.dart';
import '../../common/widget/LineChartWidget.dart';
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

  double maxPrice = 0;
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
          maxPrice = max(price, maxPrice);
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
      body: Stack(
        children: [

          const LiveBackgroundWidget(
            shape: ParticleShapeType.square,
            velocityY: -5,
            particleMinSize: 5,
            particleMaxSize: 25,
            particleCount: 3000,
            palette: Palette(
              colors: [
                Color(0xFF50E4FF),
                Color(0xFF2196F3),
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  '현재 비트코인 가격'.text.size(30).bold.make(),
                  AnimatedNumberText(
                    priceString,
                    textStyle: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                      duration: 50.ms,
                  ),
                  LineChartWidget(priceList, maxPrice: maxPrice),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
