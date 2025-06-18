import 'package:display_masjid/body/header/header.dart';
import 'package:display_masjid/body/widgetquran/widgetquran.dart';
import 'package:display_masjid/model/waktusholat.dart';
import 'package:flutter/material.dart';

class DisplayBody extends StatelessWidget {
  // get waktu sholat
  final List<WaktuSholat> waktuSholatList;
  final List<dynamic> waktuAzan;

  const DisplayBody({
    super.key,
    required this.waktuSholatList,
    required this.waktuAzan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DisplayHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: DisplayWidgetQuran(
              waktuSholat: waktuSholatList,
              waktuAzan: waktuAzan,
            ),
          ),
        ),
      ],
    );
  }
}
