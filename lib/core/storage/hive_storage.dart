import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  HiveStorage._();

  static const tasksBoxName = 'tasks_box';
  static const snackySessionBoxName = 'snacky_session_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<String>(tasksBoxName),
      Hive.openBox<String>(snackySessionBoxName),
    ]);
  }

  static Box<String> tasksBox() => Hive.box<String>(tasksBoxName);

  static Box<String> snackySessionBox() =>
      Hive.box<String>(snackySessionBoxName);
}
