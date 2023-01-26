import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro_countdown/controllers/countdown_controller.dart';
import 'package:pomodoro_countdown/responsive.dart';

class StartPomodoro extends StatefulWidget {
  const StartPomodoro({Key? key}) : super(key: key);

//final DateTime end;

  @override
  State<StartPomodoro> createState() => _StartPomodoroState();
}

class _StartPomodoroState extends State<StartPomodoro>
    with TickerProviderStateMixin {
  String startPausedText = 'start'.tr;
  String stopText = 'stop'.tr;
  final CountDownController _countDownController = Get.find();

  @override
  void initState() {
    super.initState();
    _countDownController.createAnimationController(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff6351c5),
        //  backgroundColor:
        // LongBreak ? const Color(0xffD94530) : const Color(0xff6351c5),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
            //  rect:  Rect.fromLTRB(0, 0, 0, 0),
              child: CustomPaint(painter: _countDownController.painter),
            ),
            const Align(
              alignment: Alignment.topCenter,
              // child: Container(
              //   color: Color.fromARGB(255, 0, 0, 0),
              //   // height: controller.value * 580,
              // ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
               // verticalDirection: VerticalDirection.up,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 75.0, horizontal: 35.0),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffFAFAFA),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Hyper-focused on... (+add task)",
                                        style: GoogleFonts.nunito(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Column(
                                  children: <Widget>[
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection:
                                                Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(2, 0, 2, 0),
                                                  child: Obx(
                                                    () => Text(
                                                      _countDownController
                                                          .timerString
                                                          .value,
                                                      style: GoogleFonts
                                                          .nunito(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 8,
                                                        fontSize: 57.0,
                                                        color: const Color(
                                                            0xff3B3B3B),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection:
                                                Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              textDirection:
                                                  TextDirection.ltr,
                                              mainAxisSize:
                                                  MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .fromLTRB(
                                                      13, 0, 26, 0),
                                                  child: Text(
                                                    'Hours',
                                                    style:
                                                        GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20.0,
                                                      color: const Color(
                                                          0xff3B3B3B),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .fromLTRB(
                                                      13, 0, 26, 0),
                                                  child: Text(
                                                    'Minutes',
                                                    style:
                                                        GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20.0,
                                                      color: const Color(
                                                          0xff3B3B3B),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 0, 0, 0),
                                                  child: Text(
                                                    'Seconds',
                                                    style:
                                                        GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20.0,
                                                      color: const Color(
                                                          0xff3B3B3B),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
