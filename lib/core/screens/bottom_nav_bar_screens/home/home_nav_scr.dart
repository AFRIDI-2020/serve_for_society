import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/models/event.dart';
import 'package:volunteer_project/core/models/event_creator.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/event/event_preview.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class HomeNavScr extends StatefulWidget {
  const HomeNavScr({Key? key}) : super(key: key);

  @override
  State<HomeNavScr> createState() => _HomeNavScrState();
}

class _HomeNavScrState extends State<HomeNavScr> {
  final Stream<QuerySnapshot> _eventStream =
      FirebaseFirestore.instance.collection('events').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _eventStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: customText(Strings.noEventsFound, Colors.black,
                FontSize.smallFont, FontWeight.w500),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return EventPreview(eventId: snapshot.data!.docs[index][Strings.dbEventId]);
          },
        );
      },
    );
  }
}
