import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:todiary/core/utils/app_colors.dart';
import 'package:todiary/core/utils/app_constants.dart';
import 'package:todiary/core/utils/app_strings.dart';
import 'package:todiary/data/model/task.dart';
import 'package:todiary/view/base_widget.dart';
import 'package:todiary/view/components/slider_drawer.dart';
import 'package:todiary/view/extensions/space_exs.dart';
import 'package:todiary/view/widgets/fab.dart';
import 'package:todiary/view/components/home_app_bar.dart';
import 'package:todiary/view/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (context, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();
        tasks.sort(
          (a, b) => a.createdAtDate.compareTo(b.createdAtDate),
        );
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: const FAB(),
          body: SliderDrawer(
            key: drawerKey,
            isDraggable: false,
            animationDuration: 1000,
            slider: CustomDrawer(),
            appBar: HomeAppBar(drawerKey: drawerKey),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  //custom app bar
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    width: double.infinity,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            value: checkDoneTask(tasks) /
                                valueOfTheIndicator(tasks),
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.primaryColor),
                          ),
                        ),
                        25.w,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.mainTitle,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            3.h,
                            Text(
                              "${checkDoneTask(tasks)} of ${tasks.length} task",
                              style: Theme.of(context).textTheme.titleMedium,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Divider(
                      thickness: 2,
                      indent: 100,
                    ),
                  ),
                  Expanded(
                    child: tasks.isNotEmpty
                        ? ListView.builder(
                            itemCount: tasks.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              var task = tasks[index];
                              return Dismissible(
                                  direction: DismissDirection.horizontal,
                                  onDismissed: (direction) {
                                    base.dataStore.dalateTask(task: task);
                                  },
                                  background: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.delete_outline,
                                        color: Colors.grey,
                                      ),
                                      8.w,
                                      const Text(
                                        AppStrings.deletedTask,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  key: Key(task.id),
                                  child: TaskItem(
                                    task: task,
                                  ));
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeIn(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Lottie.asset(lottieURL,
                                      animate: tasks.isNotEmpty ? false : true),
                                ),
                              ),
                              FadeInUp(
                                  from: 30,
                                  child: const Text(AppStrings.doneAllTask))
                            ],
                          ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
