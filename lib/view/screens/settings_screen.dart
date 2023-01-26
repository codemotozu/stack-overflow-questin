import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/countdown_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/user.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../others/logger.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _settingsController = Get.find();
  final CountDownController _countDownController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('settingsScreen'.tr),
      ),
      body: Obx(
        () => SettingsList(
          lightTheme: const SettingsThemeData(
            settingsListBackground: Colors.black,
            settingsSectionBackground: Colors.white10,
            titleTextColor: Colors.white,
            leadingIconsColor: Colors.white,
            settingsTileTextColor: Colors.white,
            tileDescriptionTextColor: Colors.white,
          ),
          sections: [
            //   _settingsController.logIn.value ? userSection() : loginSection(),
            SettingsSection(
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.work),
                  title: Text('workTime'.tr),
                  value: Text((_settingsController.secondsWork.value / 60)
                          .truncate()
                          .toString() +
                      'minutes'.tr),
                  onPressed: (BuildContext context) {
                    Get.dialog(getSettingsDialogInt(
                        'workTimeTitle'.tr,
                        'workTimeHint'.tr,
                        (_settingsController.secondsWork.value / 60).truncate(),
                        saveData,
                        'workTime'));
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.bed),
                  title: Text('restTime'.tr),
                  value: Text((_settingsController.secondsBreak.value / 60)
                          .truncate()
                          .toString() +
                      'minutes'.tr),
                  onPressed: (BuildContext context) {
                    Get.dialog(getSettingsDialogInt(
                        'restTimeTitle'.tr,
                        'restTimeHint'.tr,
                        (_settingsController.secondsBreak.value / 60)
                            .truncate(),
                        saveData,
                        'restTime'));
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.bedroom_child),
                  title: Text('longRestTime'.tr),
                  value: Text(
                      (_settingsController.secondsBreakAfterRound.value / 60)
                              .truncate()
                              .toString() +
                          'minutes'.tr),
                  onPressed: (BuildContext context) {
                    Get.dialog(getSettingsDialogInt(
                        'longRestTimeTitle'.tr,
                        'longRestTimeHint'.tr,
                        (_settingsController.secondsBreakAfterRound.value / 60)
                            .truncate(),
                        saveData,
                        'longRestTime'));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  saveData(var newData, String nameData) {
    logger.d('newData: $newData');
    logger.d('namedata: $nameData');
    switch (nameData) {
      case 'rounds':
        {
          _settingsController.rounds.value = (newData - 1);
          _countDownController.resetValues();
          break;
        }
      case 'workTime':
        {
          _settingsController.secondsWork.value = (newData * 60);
          _countDownController.resetValues();
          break;
        }
      case 'restTime':
        {
          _settingsController.secondsBreak.value = (newData * 60);
          _countDownController.resetValues();
          break;
        }
      case 'longRestTime':
        {
          _settingsController.secondsBreakAfterRound.value = (newData * 60);
          _countDownController.resetValues();
          break;
        }
      case 'nameUser':
        {
          _settingsController.currentUser?.name = newData;
          break;
        }
      case 'passwordUser':
        {
          _settingsController.currentUser?.password = newData;
          break;
        }
      case 'warningPause':
        {
          _settingsController.warningPause.value = newData;
          break;
        }
      case 'durationPeriodPauseWarning':
        {
          _settingsController.durationPeriodPauseWarning.value = newData;
          break;
        }
      case 'durationPeriodFinishedWarning':
        {
          _settingsController.durationPeriodFinishedWarning.value = newData;
          break;
        }

      default:
        {
          logger.e('wrong nameString datas');
        }
    }
    _settingsController.saveSettingsData();
  }

  getSettingsDialogInt(
    String titleString,
    String hintText,
    int val,
    Function onPress,
    String nameData,
  ) {
    int value = val;
    return AlertDialog(
      title: Text(titleString),
      content: TextField(
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: value.toString(),
          hintText: hintText,
        ),
        onChanged: (text) {
          setState(() {
            if (int.tryParse(text) == null) {
              // MySnackBar.warningSnackBar('Error'.tr, 'only number'.tr);
              return;
            }
            value = int.parse(text);
          });
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            onPress(value, nameData);
            Navigator.of(Get.overlayContext!).pop();
          },
          child: Text('ok'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(Get.overlayContext!).pop();
          },
          child: Text('cancel'.tr),
        ),
      ],
    );
  }
}
