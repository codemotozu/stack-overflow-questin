import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_countdown/responsive.dart';
import 'package:pomodoro_countdown/view/animation.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/countdown_controller.dart';
import '../../controllers/projects_controller.dart';
import '../buttons/start_stop_group_buttons.dart';
import '../items/tomato_icon.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final CountDownController _countDownController = Get.find();
  final ProjectsController _projectsController = Get.find();
  final SettingsController _settingsController = Get.find();
  final ScrollController _horizontal = ScrollController();

  @override
  void initState() {
    super.initState();
    _countDownController.createAnimationController(this);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWeb(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(175, 63, 60, 60),
        body: Center(
          child: AnimatedBuilder(
              animation: _countDownController.controller,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        color: Colors.amber,
                        height: 65,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => Scrollbar(
                              controller: _horizontal,
                              child: SingleChildScrollView(
                                controller: _horizontal,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _countDownController.listRounds
                                      .map(
                                        (e) => MouseRegion(
                                          child: TomatoIcon(e),
                                          cursor: SystemMouseCursors.click,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Obx(
                        () => Text(
                          _countDownController.currentTypeRoundString.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: Stack(
                          children: const <Widget>[
                            StartPomodoro(),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 20,
                      // child: ButtonPomodorp(),
                      child: StartStopGroupButton(),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
