import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/show_toast.dart';
import 'package:volunteer_project/utils/strings.dart';

class ChatProvider extends ChangeNotifier {
  final String chatCollection = 'chats';
  final String messageCollection = 'messages';

  Future<void> sendMessage(
      Map<String, dynamic> messageData, String groupId) async {
    try {
      await FirebaseFirestore.instance
          .collection(chatCollection)
          .doc(groupId)
          .collection(messageCollection)
          .doc(messageData[Strings.dbMsgId])
          .set(messageData)
          .then((value) {})
          .catchError((e) {
        toast('Something went wrong!');
      });
    } catch (error) {
      log("sending message failed, error - $error");
    }
  }
}
