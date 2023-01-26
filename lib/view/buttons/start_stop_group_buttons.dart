import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/countdown_controller.dart';

class StartStopGroupButton extends StatefulWidget {
  const StartStopGroupButton({Key? key}) : super(key: key);

  @override
  State<StartStopGroupButton> createState() => _StartStopGroupButtonState();
}

class _StartStopGroupButtonState extends State<StartStopGroupButton>
    with TickerProviderStateMixin {
  String startPausedText = 'Start'.tr;
  String stopText = 'stop'.tr;
  final CountDownController _countDownController = Get.find();
 



  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  child: FloatingActionButton.extended(
                    heroTag: 'btn1',
                    elevation: 0,
                    backgroundColor: const Color(0xffFAFAFA),
                    onPressed: _countDownController.startPaused,
                    label: Text(
                      _countDownController.startPausedText.value,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0,
                        color: const Color(0xff3B3B3B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
