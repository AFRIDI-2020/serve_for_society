import 'package:flutter/material.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/event/event_preview.dart';

class HomeNavScr extends StatefulWidget {
  const HomeNavScr({Key? key}) : super(key: key);

  @override
  State<HomeNavScr> createState() => _HomeNavScrState();
}

class _HomeNavScrState extends State<HomeNavScr> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index){
          return EventPreview();
        },
      ),
    );
  }
}
