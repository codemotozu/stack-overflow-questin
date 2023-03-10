import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:pomodoro_countdown/view/animation.dart';
import 'package:pomodoro_countdown/view/screens/custom_timer_palette.dart';
import 'projects_controller.dart';
import 'ring_controlller.dart';
import 'settings_controller.dart';
// import '../view/dialogs_snackbars/my_snack_bar.dart';

import '../others/logger.dart';
// import '../view/custom_timer_painter.dart';

enum stateCountdown {
  play,
  stop,
  pause,
}

enum typeRound {
  breaking,
  working,
}

enum stateRound {
  undone,
  done,
}

class CountDownController extends GetxController {
  final SettingsController _settingsController = Get.find();
  final RingController _ringController = Get.find();
  final ProjectsController _projectsController = Get.find();

  Rx<stateCountdown> stateCount = Rx(stateCountdown.stop);
  RxString startPausedText = RxString('> Start'.tr);
  RxString stopText = RxString('stop'.tr);
  late AnimationController controller;
  RxInt currentRoundSeconds = RxInt(0);
  typeRound currentRoundType = typeRound.working;
  RxInt currentRoundNumber = RxInt(0);
  late Duration currentDuration;
  late PausableTimer timer;
  late TickerProvider tickerProvider;
  late CustomTimePainter painter;
  RxString timerString = RxString('');
  late Timer secondTimer;
  Timer? pauseTimer;
  Timer? finishedTimer;
  RxList<Rx<stateRound>> listRounds = RxList();
  bool isFromPause = false;
  RxString currentTypeRoundString = RxString('');

  createAnimationController(TickerProvider ticker) {
    currentRoundType = typeRound.working;
    _changeCurrentRoundTypeString();
    tickerProvider = ticker;
    currentRoundSeconds.value = currentRoundType == typeRound.working
        ? _settingsController.secondsWork.value
        : currentRoundNumber.value < _settingsController.rounds.value
            ? _settingsController.secondsBreak.value
            : _settingsController.secondsBreakAfterRound.value;
    restartTimers();
    controller = AnimationController(
      vsync: tickerProvider,
      duration: currentDuration,
    );
    logger.d(controller.value);
    painter = CustomTimePainter(
      backgroundColor: const Color.fromARGB(0, 33, 149, 243),
      color: const Color(0xffD94530),
      animation: controller,
    );
    timerString.value =
        '${(currentDuration.inHours).toString().padLeft(2, '0')}:${(currentDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}';
    listRounds.value = List.generate(
        _settingsController.rounds.value + 1, (index) => Rx(stateRound.undone));
  }

  resetValues() {
    currentRoundType = typeRound.working;
    _changeCurrentRoundTypeString();
    currentRoundSeconds.value = currentRoundType == typeRound.working
        ? _settingsController.secondsWork.value
        : currentRoundNumber.value < _settingsController.rounds.value
            ? _settingsController.secondsBreak.value
            : _settingsController.secondsBreakAfterRound.value;
    restartTimers();
    controller = AnimationController(
      vsync: tickerProvider,
      duration: currentDuration,
    );
    painter = CustomTimePainter(
      backgroundColor: const Color.fromARGB(0, 255, 235, 59),
      color: const Color(0xffD94530),
      animation: controller,
    );
    logger.d(controller.value);
    timerString.value =
        '${(currentDuration.inHours).toString().padLeft(2, '0')}:${(currentDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}';
    listRounds.value = List.generate(
        _settingsController.rounds.value + 1, (index) => Rx(stateRound.undone));
    pauseTimer?.cancel();
    finishedTimer?.cancel();
  }

  restartTimers() {
    currentDuration = Duration(seconds: currentRoundSeconds.value);
    timer = PausableTimer(currentDuration, () {
      _endRound(true);
    });

    pauseTimer?.cancel();
    finishedTimer?.cancel();
  }

  _changedTextStartPaused(stateCountdown state) {
    if (state == stateCountdown.pause) {
      startPausedText.value = '> Start'.tr;
    }
    if (state == stateCountdown.play) {
      startPausedText.value = '|| Pause'.tr;
    }
    if (state == stateCountdown.stop) {
      startPausedText.value = '> Start'.tr;
    }
  }

  startPaused() {
    if (stateCount.value == stateCountdown.pause ||
        stateCount.value == stateCountdown.stop) {
      if (!isFromPause) {
        if (currentRoundType == typeRound.working) {
          _ringController.playStartWorking();
        } else {
          _ringController.playStartBreaking();
        }
      }
      stateCount.value = stateCountdown.play;
      currentDuration = Duration(seconds: currentRoundSeconds.value);
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
      const oneDecimal = Duration(milliseconds: 100);
      secondTimer = Timer.periodic(oneDecimal, (Timer timer) {
        Duration duration = controller.duration! * controller.value;
        timerString.value =
            '${(currentDuration.inHours).toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
      });

      if (pauseTimer != null) {
        pauseTimer?.cancel();
      }
      if (finishedTimer != null) {
        finishedTimer?.cancel();
      }
      timer.start();
    } else if (stateCount.value == stateCountdown.play) {
      isFromPause = true;
      stateCount.value = stateCountdown.pause;
      timer.pause();
      secondTimer.cancel();
      controller.stop();
      currentRoundSeconds.value = currentDuration.inSeconds;
      pauseTimer = Timer.periodic(
          Duration(
              seconds: _settingsController.durationPeriodPauseWarning.value),
          (timer) {
        // warningPause();
      });
    }
    _changedTextStartPaused(stateCount.value);
  }

  _changeCurrentRoundTypeString() {
    if (currentRoundType == typeRound.working) {
      currentTypeRoundString.value = 'Pomodoro'.tr;
    } else {
      currentTypeRoundString.value = 'Short Break'.tr;
    }
  }

  _endRound(bool isNormalStop) {
    logger.d('here');
    isFromPause = false;
    if (currentRoundType == typeRound.working) {
      _ringController.playStopWorking();
    } else {
      _ringController.playStopBreaking();
    }
    stateCount.value = stateCountdown.stop;
    _changedTextStartPaused(stateCount.value);
    if (currentRoundType == typeRound.breaking) {
      currentRoundNumber.value++;

      if (currentRoundNumber.value > _settingsController.rounds.value) {
        currentRoundNumber.value = 0;

        for (var i = 0; i < listRounds.length; i++) {
          listRounds[i].value = stateRound.undone;
        }
      }
    } else {
      if (isNormalStop) {
        _projectsController.addDurationToProject(currentDuration);
      }
      listRounds[currentRoundNumber.value].value = stateRound.done;
    }
    currentRoundType = currentRoundType == typeRound.working
        ? typeRound.breaking
        : typeRound.working;
    _changeCurrentRoundTypeString();
    if (currentRoundNumber.value == _settingsController.rounds.value &&
        currentRoundType == typeRound.breaking) {
      currentRoundSeconds.value =
          _settingsController.secondsBreakAfterRound.value;
    } else {
      currentRoundSeconds.value = currentRoundType == typeRound.working
          ? _settingsController.secondsWork.value
          : _settingsController.secondsBreak.value;
    }

    restartTimers();
    secondTimer.cancel();
    timerString.value =
        '${(currentDuration.inHours).toString().padLeft(2, '0')}:${(currentDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}';
    controller.duration = currentDuration;
    _changeCurrentRoundTypeString();
    finishedTimer = Timer.periodic(
        Duration(
            seconds: _settingsController.durationPeriodFinishedWarning.value),
        (timer) {
      // warningTimeFinished();
    });
  }

  // warningPause() {
  //   if (_settingsController.warningPause.value) {
  //     if (currentRoundType == typeRound.breaking) {
  //       MySnackBar.warningSnackBar(
  //           'Pause'.tr, 'We are waiting to continue breaking.'.tr);
  //       _ringController.playRingWarning();
  //     }
  //     if (currentRoundType == typeRound.working) {
  //       MySnackBar.warningSnackBar(
  //           'Pause'.tr, 'We are waiting to continue working.'.tr);
  //       _ringController.playRingWarning();
  //     }
  //   }
  // }

  // warningTimeFinished() {
  //   if (currentRoundType == typeRound.breaking &&
  //       _settingsController.warningTimeEndingAfterWork.value) {
  //     MySnackBar.warningSnackBar(
  //         'Break is finished'.tr, 'It is time for work.'.tr);
  //     _ringController.playRingWarning();
  //   }
  //   if (currentRoundType == typeRound.working &&
  //       _settingsController.warningTimeEndingAfterBreak.value) {
  //     MySnackBar.warningSnackBar(
  //         'Work is finished'.tr, 'It is time for rest.'.tr);
  //     _ringController.playRingWarning();
  //   }
  // }

  int nextSecond() {
    if (currentRoundType == typeRound.working) {
      if (currentRoundNumber == _settingsController.rounds) {
        return _settingsController.secondsBreakAfterRound.value;
      } else {
        return _settingsController.secondsBreak.value;
      }
    } else {
      return _settingsController.secondsWork.value;
    }
  }

  stop() {
    if (stateCount.value != stateCountdown.play) {
      return;
    }
    Duration duration = timer.elapsed;
    if (currentRoundType == typeRound.working) {
      _projectsController.addDurationToProject(duration);
    }
    controller.value = 0;
    timer.cancel();
    _endRound(false);
  }
}
