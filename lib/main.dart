// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pomodoro_countdown/pomodoro_drawer.dart';
import 'controllers/countdown_controller.dart';
import 'controllers/file_controller.dart';
import 'controllers/projects_controller.dart';
import 'controllers/ring_controlller.dart';
import 'controllers/settings_controller.dart';
import 'view/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init();
  final FileController _fileController = Get.put(FileController());
  final SettingsController _settingsController = Get.put(SettingsController());
  final RingController _ringController = Get.put(RingController());
  final ProjectsController _projectControlller = Get.put(ProjectsController());
  final CountDownController _countDownController =
      Get.put(CountDownController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SettingsController _settingsController = Get.find();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.red,
      ),
      // translations: Languages(),
      locale: _settingsController.language,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Pomodoro countdown'.tr),
      ),
      drawer: PomodoroDrawer(),
      body: const MainScreen(),
    );
  }
}
