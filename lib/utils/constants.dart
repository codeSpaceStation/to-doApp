import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/app_str.dart';

/// Alamat lottie asset
String lottieURL = 'assets/lottie/1.json';

/// Empty title of subTitle textfield warning
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You must fill all fields!',
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );
}

/// Nothing entered when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You must edit the task then try to update it!',
    corner: 20.0,
    duration: 5000,
    padding: const EdgeInsets.all(20),
  );
}

/// No Task warning dialog for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppStr.oopsMsg,
    message:
        "There is no task for delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
    noImage: true,
  );
}

/// Delete All task from DB dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message:
        "Do you really want to delete all task? You will no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapConfirm: () {
      /// We'll clear all box data using this commad later on
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
    noImage: true,
  );
}
