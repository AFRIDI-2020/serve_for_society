import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/models/group.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/chat_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class ChattingScreen extends StatefulWidget {
  final Group group;

  const ChattingScreen({Key? key, required this.group}) : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final messageTextController = TextEditingController();
  String? messageText;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final authProvider = Provider.of<AuthProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () async {
                Navigator.pop(context, true);
              }),
          toolbarHeight: size.height * .08,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: widget.group.groupImage != ''
                    ? CachedNetworkImageProvider(widget.group.groupImage)
                    : const AssetImage("assets/ic_group.png") as ImageProvider,
                radius: size.width * .05,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(widget.group.groupName,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.black, fontSize: FontSize.mediumFont)),
              )
            ],
          )),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.group.groupId)
            .collection('messages')
        .orderBy(Strings.dbDate, descending: false)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

          if(!snapshot.hasData){
            return Center(
              child: customText("No chat yet!", Colors.grey, FontSize.mediumFont, FontWeight.normal),
            );
          }

          // if(snapshot.connectionState == ConnectionState.waiting){
          //   return const Center(child: CircularProgressIndicator());
          // }

          return Stack(
            children: [
              Padding(
                  padding: EdgeInsets.all(size.width * .05),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      bool isSender = doc[Strings.dbSender][Strings.dbUserId] == authProvider.currentUser.userId? true : false;
                      return _message(size, doc[Strings.dbMessage], isSender, doc[Strings.dbSender][Strings.dbProfileImage], doc[Strings.dbDate]);
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
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Write your message...',
                            contentPadding: EdgeInsets.fromLTRB(
                                size.width * .03, size.width * .06, 0.0, 0.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(size.width * .04),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(size.width * .04),
                                borderSide: BorderSide(color: Colors.grey)),
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
                            sendMessage(authProvider, chatProvider);
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
    );
  }

  Widget _message(Size size, String msg, bool isSender, String image, int date) =>
      Column(
        children: [
          Row(
            mainAxisAlignment: isSender?MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if(!isSender)
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: image != ''
                    ? CachedNetworkImageProvider(image)
                    : const AssetImage("assets/profile_image_demo.png") as ImageProvider,
                radius: size.width * .06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: isSender? Colors.grey.shade200 :Colors.green.withOpacity(.8),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                size.width * .03,
                              ),
                              topRight: Radius.circular(
                                size.width * .03,
                              ))),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .03, vertical: size.width * .03),
                      child: Text(
                        msg,
                        style: TextStyle(
                            color: isSender? Colors.black : Colors.white, fontSize: size.width * .04),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(date)),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.black, fontSize: FontSize.xSmallFont),
                    ),
                  ],
                ),
              ),
              if(isSender)
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: image != ''
                      ? CachedNetworkImageProvider(image)
                      : const AssetImage("assets/profile_image_demo.png") as ImageProvider,
                  radius: size.width * .06,
                ),
            ],
          ),

          SizedBox(
            height: size.width * .04,
          ),
        ],
      );

  void sendMessage(AuthProvider authProvider, ChatProvider chatProvider) async {
    if (messageTextController.text.isEmpty) {
      return;
    }
    String msgId = const Uuid().v4();
    Map<String, dynamic> messageData = {
      Strings.dbMsgId: msgId,
      Strings.dbSender: authProvider.getCreatedBy(authProvider.currentUser),
      Strings.dbDate: DateTime
          .now()
          .millisecondsSinceEpoch,
      Strings.dbGroupId: widget.group.groupId,
      Strings.dbMessage: messageTextController.text.trim()
    };
    await chatProvider.sendMessage(messageData, widget.group.groupId);
    setState(() {
      messageTextController.clear();
    });
  }
}
