import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/components/fab.dart';
import 'package:todo_app/views/home/components/home_app_bar.dart';
import 'package:todo_app/views/home/components/slider_drawer.dart';
import 'package:todo_app/views/home/widget/task_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Cek nilai dari circle indikator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  /// Cek task yang selesai
  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// Untuk sorting list
          tasks.sort(
            (a, b) => a.createdAtDate.compareTo(b.createdAtDate),
          );

          return Scaffold(
            backgroundColor: Colors.white,

            // FAB
            floatingActionButton: Fab(),

            /// Body
            body: SliderDrawer(
              key: dKey,
              isDraggable: false,
              animationDuration: 1000,

              appBar: HomeAppBar(drawerKey: dKey),

              ///Drawer
              slider: CustomDrawer(),

              ///Main Body
              child: _buildHomeBody(textTheme, base, tasks),
            ),
          );
        });
  }

  /// Home Body
  Widget _buildHomeBody(
      TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          ///Kustom App Bar
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Idikator progres
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),

                ///Space
                25.w,

                /// Top Level info task
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    3.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: textTheme.titleMedium,
                    )
                  ],
                )
              ],
            ),
          ),

          //Divider
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          /// List of Task
          Expanded(
            // width: double.infinity,
            // height: 585,
            child: tasks.isNotEmpty

                /// Task list tidak kosong
                ? ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      /// Get single Task for showing in list
                      var task = tasks[index];
                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        onDismissed: (_) {
                          /// menghapus task sekarang dari DB
                          base.dataStore.deleteTask(task: task);
                        },
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.grey,
                            ),
                            8.w,
                            const Text(
                              AppStr.deletedTask,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        key: Key(task.id),
                        child: TaskWidget(task: task),
                      );
                    })

                /// Task list kosong
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Lottie Anime
                        FadeIn(
                          child: SizedBox(
                            width: 320,
                            height: 320,
                            child: Lottie.asset(
                              lottieURL,
                              animate: tasks.isNotEmpty ? false : true,
                            ),
                          ),
                        ),

                        /// Sub text
                        FadeInUp(
                          from: 30,
                          child: const Text(
                            AppStr.doneAllTask,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
