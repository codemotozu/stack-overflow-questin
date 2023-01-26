import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pomodoro_countdown/view/screens/settings_screen.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/projects_controller.dart';

class PomodoroDrawer extends StatefulWidget {
  final ProjectsController _projectsController = Get.find();

  PomodoroDrawer({Key? key}) : super(key: key);

  @override
  State<PomodoroDrawer> createState() => _PomodoroDrawerState();
}

class _PomodoroDrawerState extends State<PomodoroDrawer> {
  final SettingsController _settingsController = Get.find();
  final ProjectsController _projectsController = Get.find();
  final colorList = <Color>[
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        // Important: Remove any padding from the ListView.
      
        children: [
     
          ListTile(
            tileColor: Colors.white24,
            title: Text('openSettings'.tr,
                style: const TextStyle(color: Colors.white)),
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
