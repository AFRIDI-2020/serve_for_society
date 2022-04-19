import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/dialogs/review_dialog.dart';
import 'package:volunteer_project/core/screens/feedbacks/feedback_item.dart';
import 'package:volunteer_project/utils/theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: customText('Feedback', Colors.black, FontSize.largeFont, FontWeight.normal),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: (){
            showReviewDialog(context);
          }, icon: const Icon(
            Icons.drive_file_rename_outline,
            color: Colors.black,
          ),)
        ],
      ),
      body: _bodyUI(),
    );
  }
  
  /// screen body
  Widget _bodyUI() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
    margin: const EdgeInsets.only(top: 40),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      color: darkGreen
    ),
    child: ListView(
      children: [
        customText('People Share Their Thoughts About The Event', Colors.white, 24, FontWeight.bold),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index){
            return const FeedbackItem();
          },
        )
      ],
    ),
  );
}
