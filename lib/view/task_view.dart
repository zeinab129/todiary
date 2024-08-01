import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todiary/core/utils/app_colors.dart';
import 'package:todiary/core/utils/app_constants.dart';
import 'package:todiary/core/utils/app_strings.dart';
import 'package:todiary/data/model/task.dart';
import 'package:todiary/view/base_widget.dart';
import 'package:todiary/view/extensions/space_exs.dart';
import 'package:todiary/view/widgets/custom_text_field.dart';
import 'package:todiary/view/widgets/date_time_picker_field.dart';
import 'package:todiary/view/widgets/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  const TaskView(
      {super.key,
      required this.task,
      required this.titleTaskController,
      required this.descriptionTaskController});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  dynamic isTaskAlreadyExistUpdateTask() {
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subtitle;

        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.pop(context);
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title,
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  dynamic deleteTask() {
    return widget.task?.delete();
  }

  bool isTaskAlreadyExistBool() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: const TaskViewAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      RichText(
                          text: TextSpan(
                              text: isTaskAlreadyExistBool()
                                  ? AppStrings.addNewTask
                                  : AppStrings.updateCurrentTask,
                              style: Theme.of(context).textTheme.labelSmall,
                              children: const [
                            TextSpan(
                                text: AppStrings.taskStrnig,
                                style: TextStyle(fontWeight: FontWeight.w400))
                          ])),
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          AppStrings.titleOfTitleTextField,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      CustomTextField(
                        controller: widget.titleTaskController,
                        isForDesc: false,
                        onChanged: (String inputTitle) {
                          title = inputTitle;
                        },
                        onFieldSubmitted: (String inputTitle) {
                          title = inputTitle;
                        },
                      ),
                      10.h,
                      CustomTextField(
                        controller: widget.descriptionTaskController,
                        isForDesc: true,
                        onChanged: (String inputSubTitle) {
                          subtitle = inputSubTitle;
                        },
                        onFieldSubmitted: (String inputSubTitle) {
                          subtitle = inputSubTitle;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 300,
                                child: TimePickerWidget(
                                  initDateTime: showTimeAsDateTime(time),
                                  onChange: (dateTime, selectedIndex) {},
                                  dateFormat: 'HH:mm',
                                  onConfirm: (dateTime, selectedIndex) {
                                    setState(() {
                                      if (widget.task?.createdAtTime == null) {
                                        time = dateTime;
                                      } else {
                                        widget.task?.createdAtTime = dateTime;
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: DateTimePickerField(
                            title: AppStrings.timeString,
                            onTap: () {

                            },
                            isTime: true,
                            time: showTime(time)),
                      ),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            maxDateTime: DateTime(2030, 4, 5),
                            minDateTime: DateTime.now(),
                            initialDateTime: showDateAsDateTime(date),
                            onConfirm: (dateTime, selectedIndex) {
                              setState(() {
                                if (widget.task?.createdAtDate == null) {
                                  date = dateTime;
                                } else {
                                  widget.task?.createdAtDate = dateTime;
                                }
                              });
                            },
                          );
                        },
                        child: DateTimePickerField(
                          title: AppStrings.dateString,
                          time: showDate(date),
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                ),
                24.h,
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: isTaskAlreadyExistBool()
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceEvenly,
                    children: [
                      isTaskAlreadyExistBool()
                          ? Container()
                          : MaterialButton(
                              onPressed: () {
                                deleteTask();
                                Navigator.pop(context);
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              height: 55,
                              minWidth: 150,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: AppColors.primaryColor,
                                  ),
                                  Text(
                                    AppStrings.deleteTask,
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                      MaterialButton(
                        onPressed: () {
                          isTaskAlreadyExistUpdateTask();
                        },
                        color: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        height: 55,
                        minWidth: 150,
                        child: Text(
                          isTaskAlreadyExistBool()
                              ? AppStrings.addTaskString
                              : AppStrings.updateTaskString,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
