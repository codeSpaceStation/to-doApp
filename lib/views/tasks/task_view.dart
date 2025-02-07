import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/tasks/components/date_time_selection.dart';
import 'package:todo_app/views/tasks/components/rep_textfield.dart';
import 'package:todo_app/views/tasks/widget/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {super.key,
      required this.titleTaskController,
      required this.descriptionTaskController,
      required this.task});

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  /// Show selected Time as String Format
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

  /// Show selected date as String Format
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

  /// Show selected date as dateFormat for init Time
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

  /// If any task already exist return true otherwise false
  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// Main Func for creating or updating task
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    /// DISINI KITA UPDATE CURRENT TASK
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;

        widget.task?.save();

        /// poP Page
        Navigator.of(context).pop(context);
      } catch (e) {
        /// jika pengguna ingin update task tetapi menginput nothing kita akan tampilkan warning ini
        updateTaskWarning(context);
      }
    }

    /// DISINI KITA MEMBUAT SEBUAH TASK BARU
    else {
      if (title != null && subTitle != null) {
        var task = Task.create(
            title: title,
            subTitle: subTitle,
            createdAtDate: date,
            createdAtTime: time);

        /// We are adding this new task to Hive DB using inheritedWidget
        BaseWidget.of(context).dataStore.addTask(task: task);

        /// pop page
        Navigator.pop(context);
      } else {
        /// Warning
        emptyWarning(context);
      }
    }
  }

  /// Hapus task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme; // Box Decoration
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,

        ///App Bar
        appBar: const TaskViewAppBar(),

        ///Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// Top Side teks
                _buildTopSideTexts(textTheme),

                /// Main Task View Activity
                _buildMainTaskViewActivity(
                  textTheme,
                  context,
                ),

                /// Bottom Side Buttons
                _buildBottomSideButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Side Buttons
  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
              ? Container()
              :

              /// Menghapus current Task button
              Container(
                  width: 150,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      deleteTask();
                      Navigator.pop(context);
                    },
                    minWidth: 150,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 55,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.close_rounded,
                          color: AppColors.primaryColor,
                        ),
                        5.w,
                        const Text(
                          AppStr.deleteTask,
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),

          /// Menambah atau Update task
          MaterialButton(
            onPressed: () {
              /// tambah atau Update task Activity
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            height: 55,
            child: Text(
              isTaskAlreadyExist()
                  ? AppStr.addTaskString
                  : AppStr.updateTaskString,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Main Task View Activity
  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 535,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title of TextField
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),

          ///Judul Taks
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.titleTaskController,
                maxLines: 6,
                cursorHeight: 60,
                style: const TextStyle(
                  color: Color.fromARGB(255, 20, 20, 20),
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (String inputTitle) {
                  title = inputTitle;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (String inputTitle) {
                  title = inputTitle;
                },
              ),
            ),
          ),

          10.h,

          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.descriptionTaskController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.bookmark_border, color: Colors.grey),
                  border: InputBorder.none,
                  counter: Container(),
                  hintText: AppStr.addNote,
                ),
                onFieldSubmitted: (value) {
                  subTitle = value;
                },
                onChanged: (value) {
                  subTitle = value;
                },
              ),
            ),
          ),

          /// Task Title
          // RepTextField(
          //   controller:
          //       widget.descriptionTaskController ?? TextEditingController(),
          //   isForDescription: true,
          //   onFieldSubmitted: (String inputSubTitle) {
          //     subTitle = inputSubTitle;
          //   },
          //   onChanged: (String inputSubTitle) {
          //     subTitle = inputSubTitle;
          //   },
          // ),

          /// Pemilihan Waktu / time selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 280,
                  child: TimePickerWidget(
                    initDateTime: showDateAsDateTime(time),
                    dateFormat: 'HH:mm',
                    pickerTheme: DateTimePickerTheme(
                      confirmTextStyle:
                          const TextStyle(color: AppColors.primaryColor),
                      cancelTextStyle: const TextStyle(color: Colors.grey),
                    ),
                    onChange: (_, __) {},
                    onConfirm: (dateTime, _) {
                      setState(() {
                        if (widget.task?.createdAtTime == null) {
                          time = dateTime;
                        } else {
                          widget.task!.createdAtTime = dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            title: AppStr.timeString,

            ///For testing
            time: showTime(time),
          ),

          /// Pemilihan tanggal / date selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                pickerTheme: DateTimePickerTheme(
                  confirmTextStyle:
                      const TextStyle(color: AppColors.primaryColor),
                  cancelTextStyle: const TextStyle(color: Colors.grey),
                ),
                maxDateTime: DateTime(2030, 9, 22),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                },
              );
            },
            title: AppStr.dateString,
            isTime: true,

            ///For Testing
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  /// Top Side Texts
  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Divider - grey
          const Expanded(
            child: SizedBox(
              width: 70,
              child: Divider(
                thickness: 2,
              ),
            ),
          ),

          ///  nanti sesuai kondisi task yang kita putuskan untuk "add new task"
          /// or "Update current task"
          RichText(
            text: TextSpan(
              text: isTaskAlreadyExist()
                  ? AppStr.addNewTask
                  : AppStr.updateCurrentTask,
              style: textTheme.titleLarge,
              children: const <InlineSpan>[
                TextSpan(
                  text: AppStr.taskString,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          /// Divider - grey
          const Expanded(
            child: SizedBox(
              width: 70,
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
