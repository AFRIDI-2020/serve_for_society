import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/show_toast.dart';
import 'package:volunteer_project/core/models/event.dart';
import 'package:volunteer_project/core/models/event_creator.dart';
import 'package:volunteer_project/core/models/group.dart';
import 'package:volunteer_project/core/models/review.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/utils/strings.dart';

class EventProvider extends ChangeNotifier {
  final String eventCollection = 'events';
  final String reviewCollection = 'reviews';
  final String chatCollection = 'chats';
  List<Event> eventList = [];
  List<Review> reviewList = [];
  List<Group> chatGroups = [];

  Future<bool> createEvent(Map<String, dynamic> eventDetails,
      Map<String, dynamic> chatGroupData) async {
    bool isSuccessful = false;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventDetails[Strings.dbEventId])
          .set(eventDetails)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection(chatCollection)
            .doc(chatGroupData[Strings.dbGroupId])
            .set(chatGroupData)
            .then((value) {
          toast(Strings.eventCreatedSuccessfully);
          isSuccessful = true;
        });
      }).catchError((error) {
        log("Event not created, $error");
        toast(Strings.somethingWentWrong);
        isSuccessful = false;
      });
      return isSuccessful;
    } catch (e) {
      log("Creating event failed, $e");
      toast(Strings.somethingWentWrong);
      return false;
    }
  }

  Future<String?> uploadEventImage(File? file, String id) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('event_images').child(id);

    if (file != null) {
      UploadTask uploadTask = ref.putFile(File(file.path));
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    }
    return null;
  }

  Future getAllEvents() async {
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .get()
          .then((snapshot) {
        eventList.clear();
        for (var element in snapshot.docChanges) {
          Event event = Event(
              eventId: element.doc[Strings.dbEventId],
              createdAt: element.doc[Strings.dbCreatedAt],
              createdBy: EventCreator(
                userId: element.doc[Strings.dbCreatedBy][Strings.dbUserId],
                username: element.doc[Strings.dbCreatedBy][Strings.dbUsername],
                mobileNo: element.doc[Strings.dbCreatedBy][Strings.dbMobileNo],
                address: element.doc[Strings.dbCreatedBy][Strings.dbAddress],
                aboutUser: element.doc[Strings.dbCreatedBy]
                    [Strings.dbAboutUser],
                profileImage: element.doc[Strings.dbCreatedBy]
                    [Strings.dbProfileImage],
              ),
              image: element.doc[Strings.dbEventImage],
              description: element.doc[Strings.dbEventDescription],
              peopleNeed: element.doc[Strings.dbEventPeopleNeed],
              tasks: element.doc[Strings.dbEventTasks],
              members: element.doc[Strings.dbMembers],
              address: element.doc[Strings.dbEventAddress],
              appreciation: element.doc[Strings.dbAppreciation]);
          eventList.add(event);
        }
      });
      log("total events: ${eventList.length}");
      notifyListeners();
    } catch (error) {
      log("Fetching all events failed, error - $error");
    }
  }

  Future<bool> joinEvent(String eventId, AuthProvider authProvider) async {
    bool isSuccessful = true;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .get()
          .then((value) async {
        int peopleNeed = int.parse(value.data()![Strings.dbEventPeopleNeed]);
        List<dynamic> members = value.data()![Strings.dbMembers];
        if (value.data()![Strings.dbMembers].length < peopleNeed) {
          members.add(authProvider.getCreatedBy(authProvider.currentUser));
          await FirebaseFirestore.instance
              .collection(eventCollection)
              .doc(eventId)
              .update({Strings.dbMembers: members});

          await FirebaseFirestore.instance
              .collection(chatCollection)
              .doc(eventId)
              .get()
              .then((documentSnapshot) async {
            List<dynamic> members = documentSnapshot[Strings.dbMembers];
            members.add(authProvider.getCreatedBy(authProvider.currentUser));
            await FirebaseFirestore.instance
                .collection(chatCollection)
                .doc(eventId)
                .update({Strings.dbMembers: members});
          });
        } else {
          isSuccessful = false;
        }
      });
      return isSuccessful;
    } catch (e) {
      log("Joining event failed, error - $e");
      return false;
    }
  }

  Future<bool> isMemberOfEvent(
      String eventId, AuthProvider authProvider) async {
    bool isMember = false;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .get()
          .then((value) {
        var members = value.data()![Strings.dbMembers];
        for (var member in members) {
          if (member[Strings.dbUserId] == authProvider.currentUser.userId) {
            isMember = true;
            break;
          }
        }
      });
      return isMember;
    } catch (error) {
      log("membership of event check failed, error - $error");
      return false;
    }
  }

  Future<bool> hasAppreciated(String eventId, AuthProvider authProvider) async {
    bool hasAppreciated = false;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .get()
          .then((documentSnapshot) {
        List<dynamic> appreciations =
            documentSnapshot.data()![Strings.dbAppreciation];
        for (var appreciation in appreciations) {
          if (appreciation[Strings.dbUserId] ==
              authProvider.currentUser.userId) {
            hasAppreciated = true;
          }
        }
      });
      return hasAppreciated;
    } catch (e) {
      log("appreciated or not, $e");
      return false;
    }
  }

  Future<bool> appreciateEvent(
      String eventId, AuthProvider authProvider) async {
    bool isSuccessful = true;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .get()
          .then((documentSnapshot) async {
        List<dynamic> appreciations =
            documentSnapshot.data()![Strings.dbAppreciation];
        appreciations.add(authProvider.getCreatedBy(authProvider.currentUser));
        await FirebaseFirestore.instance
            .collection(eventCollection)
            .doc(eventId)
            .update({Strings.dbAppreciation: appreciations}).then((value) {
          isSuccessful = true;
        }).catchError((e) {
          isSuccessful = false;
        });
      });
      return isSuccessful;
    } catch (e) {
      log("Appreciating failed, error - $e");
      return false;
    }
  }

  Future<bool> depreciateEvent(
      String eventId, AuthProvider authProvider) async {
    bool isSuccessful = true;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .get()
          .then((documentSnapshot) async {
        List<dynamic> appreciations =
            documentSnapshot.data()![Strings.dbAppreciation];
        appreciations.removeWhere((element) =>
            element[Strings.dbUserId] == authProvider.currentUser.userId);
        await FirebaseFirestore.instance
            .collection(eventCollection)
            .doc(eventId)
            .update({Strings.dbAppreciation: appreciations}).then((value) {
          isSuccessful = true;
        }).catchError((e) {
          isSuccessful = false;
        });
      });
      return isSuccessful;
    } catch (e) {
      log("Appreciating failed, error - $e");
      return false;
    }
  }

  Future<bool> updateTask(
      String eventId, String taskId, String taskDescription, int status) async {
    bool isSuccessful = false;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .get()
          .then((documentSnapshot) async {
        if (documentSnapshot.exists) {
          List<dynamic> tasks = documentSnapshot.data()![Strings.dbEventTasks];
          tasks[tasks
                  .indexWhere((element) => element[Strings.dbTaskId] == taskId)]
              [Strings.dbTaskDescription] = taskDescription;
          tasks[tasks.indexWhere((element) =>
                  element[Strings.dbTaskId] == taskId)][Strings.dbTaskStatus] =
              status == 1
                  ? Strings.pending
                  : status == 2
                      ? Strings.onProgress
                      : Strings.completed;
          await FirebaseFirestore.instance
              .collection(eventCollection)
              .doc(eventId)
              .update({Strings.dbEventTasks: tasks}).then((value) {
            isSuccessful = true;
          }).catchError((error) {
            isSuccessful = false;
          });
        }
      });
      return isSuccessful;
    } catch (e) {
      log('updating task failed, error - $e');
      return false;
    }
  }

  Future<dynamic> getTask(String eventId, String taskId) async {
    String taskDescription = '';
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .get()
          .then((documentSnapshot) async {
        if (documentSnapshot.exists) {
          List<dynamic> tasks = documentSnapshot.data()![Strings.dbEventTasks];
          taskDescription = tasks[tasks
                  .indexWhere((element) => element[Strings.dbTaskId] == taskId)]
              [Strings.dbTaskDescription];
        } else {
          taskDescription = '';
        }
      });
      return taskDescription;
    } catch (e) {
      log('getting task failed, error - $e');
      return '';
    }
  }

  Future<bool> sendReview(
      String eventId, Map<String, dynamic> data, String reviewId) async {
    bool isSuccessful = false;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .collection(reviewCollection)
          .doc(reviewId)
          .set(data)
          .then((value) {
        isSuccessful = true;
      }).catchError((error) {
        isSuccessful = false;
      });
      return isSuccessful;
    } catch (e) {
      log('Sending review failed, error - $e');
      return false;
    }
  }

  Future<bool> hasSentReview(String eventId, AuthProvider authProvider) async {
    bool isSuccessful = false;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .collection(reviewCollection)
          .get()
          .then((snapshot) {
        for (var element in snapshot.docChanges) {
          if (element.doc[Strings.dbCreatedBy][Strings.dbUserId] ==
              authProvider.currentUser.userId) {
            isSuccessful = true;
            break;
          }
        }
      }).catchError((error) {
        isSuccessful = false;
      });
      return isSuccessful;
    } catch (e) {
      log('Sending review failed, error - $e');
      return false;
    }
  }

  Future<void> getAllReviews(String eventId) async {
    reviewList.clear();
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .collection(reviewCollection)
          .get()
          .then((snapshot) {
        for (var element in snapshot.docChanges) {
          Review review = Review(
              reviewId: element.doc[Strings.dbReviewId],
              reviewMessage: element.doc[Strings.dbReviewMsg],
              date: element.doc[Strings.dbDate],
              rating: element.doc[Strings.dbRating],
              createdBy: EventCreator(
                  userId: element.doc[Strings.dbCreatedBy][Strings.dbUserId],
                  username: element.doc[Strings.dbCreatedBy]
                      [Strings.dbUsername],
                  address: element.doc[Strings.dbCreatedBy][Strings.dbAddress],
                  profileImage: element.doc[Strings.dbCreatedBy]
                      [Strings.dbProfileImage],
                  aboutUser: element.doc[Strings.dbCreatedBy]
                      [Strings.dbAboutUser]));
          reviewList.add(review);
        }
      }).catchError((error) {
        log('fetching all reviews failed, error - $error');
      });
      notifyListeners();
    } catch (e) {
      log('fetching all reviews failed, error - $e');
    }
  }

  Future<List<Group>> getAllChats(AuthProvider authProvider) async {
    chatGroups.clear();
    try {
      await FirebaseFirestore.instance
          .collection(chatCollection)
          .get()
          .then((value) {
        for (var snapshot in value.docChanges) {
          List<dynamic> members = snapshot.doc[Strings.dbMembers];
          for (var member in members) {
            if (member[Strings.dbUserId] == authProvider.currentUser.userId) {
              Group group = Group(
                  groupId: snapshot.doc[Strings.dbGroupId],
                  eventId: snapshot.doc[Strings.dbEventId],
                  groupName: snapshot.doc[Strings.dbGroupName],
                  groupImage: snapshot.doc[Strings.dbGroupImage],
                  members: snapshot.doc[Strings.dbMembers]);
              chatGroups.add(group);
            }
          }
        }
      });
      return chatGroups;
    } catch (error) {
      log("Fetching all chats failed, error - $error");
      return [];
    }
  }

  Future<void> addComment(Map<String, dynamic> commentData) async {
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(commentData[Strings.dbEventId])
          .collection("comments")
          .doc(commentData[Strings.dbCommentId])
          .set(commentData);
    } catch (e) {
      log("adding comment failed, error -$e");
    }
  }

  Future<int> noOfComment(String eventId) async {
    int noOfComment = 0;
    try {
      await FirebaseFirestore.instance
          .collection(eventCollection)
          .doc(eventId)
          .collection("comments")
          .get().then((value){
            noOfComment = value.docs.length;
      });
      return noOfComment;
    } catch (e) {
      log("getting noOfComment comment failed, error -$e");
      return 0;
    }
  }
}
