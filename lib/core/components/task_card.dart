import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/edit_task.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class TaskCard extends StatelessWidget {
  String taskId;
  String eventId;
  Color? backgroundColor;
  Color? textColor;
  int taskNumber;
  Color? checkIconColor;
  bool? isCompleted;
  bool isPostOwner;

  TaskCard(
      {Key? key,
      this.backgroundColor,
      this.textColor,
      required this.taskNumber,
      this.checkIconColor,
      required this.isCompleted,
      this.isPostOwner = true,
      required this.taskId,
      required this.eventId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(taskNumber.toString(), textColor ?? Colors.black,
                    FontSize.xLargeFont, FontWeight.bold),
                customText('Task No', textColor ?? Colors.black,
                    FontSize.smallFont, FontWeight.normal),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: isPostOwner
                    ? InkWell(
                        onTap: () {
                          editTask(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20)),
                              color: Colors.green),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 13,
                          ),
                        ),
                      )
                    : const SizedBox()),
            Positioned(
                bottom: 2,
                right: 2,
                child: isCompleted!
                    ? Icon(
                        Icons.check_circle,
                        color: checkIconColor ?? Colors.black,
                        size: 16,
                      )
                    : const SizedBox())
          ],
        ),
      ),
    );
  }

  void editTask(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(Strings.editTask + ' ($taskNumber)', Colors.black,
                    FontSize.mediumFont, FontWeight.w500),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.clear))
              ],
            ),
            content: EditTask(
              eventId: eventId,
              taskId: taskId,
            ),
          );
        });
  }
}
