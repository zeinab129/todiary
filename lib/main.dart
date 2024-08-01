import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todiary/config/theming/app_theme.dart';
import 'package:todiary/data/hive_data_store.dart';
import 'package:todiary/data/model/task.dart';
import 'package:todiary/view/base_widget.dart';
import 'package:todiary/view/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());

  var box = await Hive.openBox<Task>(HiveDataStore.boxName);
  box.values.forEach((task) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    } else {}
  });

  runApp(BaseWidget(child: Todiary()));
}

class Todiary extends StatelessWidget {
  Todiary({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: HomeScreen(),
      //const HomeScreen(),
      // home: TaskView(),
    );
  }
}
