import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/dialogs/review_dialog.dart';
import 'package:volunteer_project/core/screens/feedbacks/feedback_item.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class FeedbackScreen extends StatefulWidget {
  final String eventId;
  const FeedbackScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool hasSentReview = false;
  bool loading = false;
  @override
  void initState() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //hasUserAlreadySentReview(eventProvider, authProvider);
      getReviews(eventProvider);
    });
    super.initState();
  }

  hasUserAlreadySentReview(EventProvider eventProvider, AuthProvider authProvider) async {
    hasSentReview = await eventProvider.hasSentReview(widget.eventId, authProvider);
    setState(() {});
  }

  getReviews(EventProvider eventProvider) async {
    setState(() {
      loading = true;
    });
    await eventProvider.getAllReviews(widget.eventId);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return StreamBuilder(
      stream:FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .collection('reviews').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }

        for (var element in snapshot.data!.docs) {
          if (element[Strings.dbCreatedBy][Strings.dbUserId] ==
              authProvider.currentUser.userId) {
            hasSentReview = true;
            break;
          }
        }
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
                if(!hasSentReview)
                  IconButton(onPressed: (){
                    showReviewDialog(context, widget.eventId);
                  }, icon: const Icon(
                    Icons.drive_file_rename_outline,
                    color: Colors.black,
                  ),)
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
              margin: const EdgeInsets.only(top: 40),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: darkGreen
              ),
              child: loading? const Center(child: CircularProgressIndicator(color: Colors.white,)) : ListView(
                children: [
                  customText('People Share Their Thoughts About The Event', Colors.white, 24, FontWeight.bold),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: eventProvider.reviewList.length,
                    itemBuilder: (context, index){
                      return FeedbackItem(review: eventProvider.reviewList[index],);
                    },
                  )
                ],
              ),
            )
        );
      },
    );
  }

}
