import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/utils/theme.dart';

class TaskCard extends StatelessWidget {
  Color? backgroundColor;
  Color? textColor;
  int taskNumber;
  Color? checkIconColor;
  bool? isCompleted;

  TaskCard(
      {this.backgroundColor,
      this.textColor,
      required this.taskNumber,
      this.checkIconColor,
      required this.isCompleted});

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
}
