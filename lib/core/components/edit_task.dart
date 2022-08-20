import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/models/event.dart';
import 'package:volunteer_project/core/models/event_creator.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class EditTask extends StatefulWidget {
  final String eventId;
  final String taskId;

  const EditTask({Key? key, required this.eventId, required this.taskId})
      : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final taskController = TextEditingController();
  bool loading = false;
  int status = 0;

  @override
  void initState() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setEventTask(eventProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                controller: taskController,
                style: const TextStyle(fontSize: FontSize.mediumFont),
                maxLength: null,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                maxLines: 5),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: status,
                  onChanged: (value){
                    setState(() {
                      status = int.parse(value.toString());
                    });
                  },
                ),
                customText(Strings.pending, Colors.black, FontSize.smallFont, FontWeight.normal)
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: status,
                  onChanged: (value){
                    setState(() {
                      status = int.parse(value.toString());
                    });
                  },
                ),
                customText(Strings.onProgress, Colors.black, FontSize.smallFont, FontWeight.normal)
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 3,
                  groupValue: status,
                  onChanged: (value){
                    setState(() {
                      status = int.parse(value.toString());
                    });
                  },
                ),
                customText(Strings.completed, Colors.black, FontSize.smallFont, FontWeight.normal)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            loading? const Center(child: CircularProgressIndicator()) : InkWell(
              onTap: () {
                saveChanges(eventProvider);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: darkGreen, borderRadius: BorderRadius.circular(4)),
                margin: const EdgeInsets.only(top: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: customText(Strings.saveChanges, Colors.white,
                    FontSize.smallFont, FontWeight.normal),
              ),
            )
          ],
        );
      },
    );
  }

  Event getEvent(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Event(
      eventId: snapshot.data![Strings.dbEventId],
      createdAt: snapshot.data![Strings.dbCreatedAt],
      createdBy: EventCreator(
        userId: snapshot.data![Strings.dbCreatedBy][Strings.dbUserId],
        username: snapshot.data![Strings.dbCreatedBy][Strings.dbUsername],
        mobileNo: snapshot.data![Strings.dbCreatedBy][Strings.dbMobileNo],
        address: snapshot.data![Strings.dbCreatedBy][Strings.dbAddress],
        aboutUser: snapshot.data![Strings.dbCreatedBy][Strings.dbAboutUser],
        profileImage: snapshot.data![Strings.dbCreatedBy]
            [Strings.dbProfileImage],
      ),
      description: snapshot.data![Strings.dbEventDescription],
      image: snapshot.data![Strings.dbEventImage],
      peopleNeed: snapshot.data![Strings.dbEventPeopleNeed],
      tasks: snapshot.data![Strings.dbEventTasks],
      members: snapshot.data![Strings.dbMembers],
      address: snapshot.data![Strings.dbEventAddress],
      appreciation: snapshot.data![Strings.dbAppreciation],
    );
  }

  void saveChanges(EventProvider eventProvider) async{
    log("clicked");
    loading = true;
    await eventProvider.updateTask(widget.eventId, widget.taskId, taskController.text, status);
    loading = false;
    setState(() {});
  }

  setEventTask(EventProvider eventProvider) async{
    taskController.text = await eventProvider.getTask(widget.eventId, widget.taskId);
    setState(() {});
  }
}
