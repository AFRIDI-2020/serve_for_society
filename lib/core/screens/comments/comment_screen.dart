import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class CommentScreen extends StatefulWidget {
  final String eventId;

  const CommentScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final messageTextController = TextEditingController();
  int totalComment = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, totalComment);
            },
          ),
          title: customText(
              'Comments', Colors.white, FontSize.largeFont, FontWeight.w500),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .doc(widget.eventId)
              .collection('comments')
              .orderBy(Strings.dbDate, descending: false)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: customText("No chat yet!", Colors.grey,
                    FontSize.mediumFont, FontWeight.normal),
              );
            }

            totalComment = snapshot.data!.docs.length;

            return Stack(
              children: [
                Padding(
                    padding: EdgeInsets.all(size.width * .05),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        return notificationView(
                            size,
                            doc[Strings.dbComment],
                            doc[Strings.dbCreatedBy][Strings.dbProfileImage],
                            doc[Strings.dbDate]);
                      },
                    )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: size.width * .17,
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: size.width * .02,
                        ),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: messageTextController,
                            autocorrect: true,
                            enableSuggestions: true,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Write here...',
                              contentPadding: EdgeInsets.fromLTRB(
                                  size.width * .03, size.width * .06, 0.0, 0.0),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(size.width * .04),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(size.width * .04),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * .04,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: size.width * .04),
                          child: IconButton(
                            onPressed: () {
                              addComment(eventProvider, authProvider);
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.green,
                              size: size.width * .08,
                            ),
                            // backgroundColor: Colors.deepOrange,
                            // elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void addComment(
      EventProvider eventProvider, AuthProvider authProvider) async {
    if (messageTextController.text.isEmpty) {
      return;
    }
    String commentId = const Uuid().v4();
    Map<String, dynamic> commentData = {
      Strings.dbCommentId: commentId,
      Strings.dbComment: messageTextController.text,
      Strings.dbDate: DateTime.now().millisecondsSinceEpoch,
      Strings.dbEventId: widget.eventId,
      Strings.dbCreatedBy: authProvider.getCreatedBy(authProvider.currentUser)
    };
    await eventProvider.addComment(commentData);
    setState(() {
      messageTextController.clear();
    });
  }

  Widget notificationView(Size size, String msg, String image, int date) =>
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: image != ''
                    ? CachedNetworkImageProvider(image)
                    : const AssetImage("assets/profile_image_demo.png")
                        as ImageProvider,
                radius: size.width * .06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .03,
                          vertical: size.width * .03),
                      child: Text(
                        msg,
                        style: TextStyle(
                            color: Colors.black, fontSize: size.width * .04),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat.yMMMd()
                          .add_jm()
                          .format(DateTime.fromMillisecondsSinceEpoch(date)),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.black, fontSize: FontSize.xSmallFont),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.width * .04,
          ),
        ],
      );

  Future<bool> onWillPop() async {
    Navigator.pop(context, totalComment);
    return true;
  }
}
