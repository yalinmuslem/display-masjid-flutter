import 'package:display_masjid/body/header/header.dart';
import 'package:display_masjid/body/widgetquran/widgetquran.dart';
import 'package:flutter/material.dart';

class DisplayBody extends StatelessWidget {
  const DisplayBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayHeader(),
        DisplayWidgetQuran(),
      ],
    );
  }
}
