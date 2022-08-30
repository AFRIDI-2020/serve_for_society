import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/dummy_text.dart';
import 'package:volunteer_project/core/components/show_toast.dart';
import 'package:volunteer_project/core/components/task_card.dart';
import 'package:volunteer_project/core/models/event.dart';
import 'package:volunteer_project/core/models/event_creator.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/event/event_members.dart';
import 'package:volunteer_project/core/screens/comments/comment_screen.dart';
import 'package:volunteer_project/core/screens/feedbacks/feedback_screen.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class EventDetails extends StatefulWidget {
  final String eventId;

  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  int _tappedIndex = 0;
  bool loading = false;
  final demoTaskList = [
    'Collecting old items and money from one\'s own area',
    'Sort out the most affected areas',
    'Dividing into two groups',
    'Distribution of relief',
    'Reporting to specific place and sharing experience and feelings'
  ];

  bool isMember(Event event, AuthProvider authProvider) {
    bool isMember = false;
    for (var member in event.members) {
      if (member[Strings.dbUserId] == authProvider.currentUser.userId) {
        isMember = true;
        break;
      }
    }
    return isMember;
  }

  bool hasAppreciated(Event event, AuthProvider authProvider) {
    bool hasAppreciated = false;
    for (var appreciation in event.appreciation) {
      if (appreciation[Strings.dbUserId] == authProvider.currentUser.userId) {
        hasAppreciated = true;
        break;
      }
    }
    return hasAppreciated;
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .doc(widget.eventId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            return Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .padding
                  .top),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 250,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          getEvent(snapshot).image != ''
                              ? CachedNetworkImage(
                            imageUrl: getEvent(snapshot).image,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(),
                                  ],
                                ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(

                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [appThemeColor, darkGreen])),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/volunteering.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                          Positioned(
                            left: 15,
                            top: 15,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle),
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              color: Colors.black38,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15),
                              height: 36,
                              child: customText(
                                  getEvent(snapshot).address,
                                  Colors.white,
                                  FontSize.smallFont,
                                  FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: circleAvaterBgColor,
                                radius: 20,
                                backgroundImage: getEvent(snapshot)
                                    .createdBy!
                                    .profileImage !=
                                    ''
                                    ? CachedNetworkImageProvider(
                                    getEvent(snapshot)
                                        .createdBy!
                                        .profileImage)
                                    : const AssetImage(
                                    'assets/profile_image_demo.png')
                                as ImageProvider,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                        getEvent(snapshot).createdBy!.username,
                                        Colors.black,
                                        FontSize.mediumFont,
                                        FontWeight.bold),
                                    const SizedBox(height: 3),
                                    customText(
                                        DateFormat("dd MMM yyyy")
                                            .add_jm()
                                            .format(DateTime
                                            .fromMillisecondsSinceEpoch(
                                            int.parse(getEvent(snapshot)
                                                .createdAt))),
                                        Colors.black,
                                        FontSize.smallFont,
                                        FontWeight.normal),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventMembers(
                                                members: getEvent(snapshot)
                                                    .members,)));
                                },
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        color: Colors.grey,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: darkGreen,
                                          ),
                                          width: 14,
                                          height: 14,
                                          alignment: Alignment.center,
                                          child: customText(
                                              getEvent(snapshot)
                                                  .members
                                                  .length
                                                  .toString(),
                                              Colors.white,
                                              FontSize.xSmallFont,
                                              FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              isMember(getEvent(snapshot), authProvider)
                                  ? customText('Joined', darkGreen,
                                  FontSize.mediumFont, FontWeight.bold)
                                  : loading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                width: 60,
                                height: 24,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: darkGreen),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
                                      joinEvent(
                                          eventProvider,
                                          authProvider,
                                          getEvent(snapshot));
                                    },
                                    child: customText(
                                        'Join',
                                        darkGreen,
                                        FontSize.mediumFont,
                                        FontWeight.w500)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ExpandableText(
                            getEvent(snapshot).description,
                            expandText: 'show more',
                            collapseText: 'show less',
                            maxLines: 5,
                            linkColor: Colors.green,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        appreciateEvent(eventProvider,
                                            authProvider, getEvent(snapshot));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              hasAppreciated(getEvent(snapshot),
                                                  authProvider)
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_alt_outlined,
                                              size: 20,
                                              color: darkGreen,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            customText(
                                                'Appreciation ',
                                                Colors.black,
                                                FontSize.mediumFont,
                                                FontWeight.normal),
                                            customText(
                                                '(${getEvent(snapshot)
                                                    .appreciation.length})',
                                                Colors.black,
                                                FontSize.smallFont,
                                                FontWeight.w500),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(eventId: widget.eventId,)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                          Icon(
                                          Icons.textsms_outlined,
                                          size: 20,
                                          color: darkGreen,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        customText(
                                            'Comments ',
                                            Colors.black,
                                            FontSize.mediumFont,
                                            FontWeight.normal),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('events')
                                              .doc(widget.eventId)
                                              .collection('comments')
                                              .orderBy(
                                              Strings.dbDate, descending: false)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot<Map<
                                                  String,
                                                  dynamic>>> snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: customText(
                                                    '(0)',
                                                    Colors.black,
                                                    FontSize.smallFont,
                                                    FontWeight.w500),
                                              );
                                            }
                                            int totalComment = snapshot.data!
                                                .docs.length;
                                            return customText(
                                                '($totalComment)',
                                                Colors.black,
                                                FontSize.smallFont,
                                                FontWeight.w500);
                                          })

                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customText(
                              'Event Tasks (${getCompletedTaskNumber(
                                  getEvent(snapshot))}/${getEvent(snapshot)
                                  .tasks.length})',
                              Colors.black,
                              FontSize.mediumFont,
                              FontWeight.w500),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: getEvent(snapshot).tasks.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _tappedIndex = index;
                                      });
                                    },
                                    child: TaskCard(
                                      eventId: getEvent(snapshot).eventId,
                                      taskId: getEvent(snapshot)
                                          .tasks[index][Strings.dbTaskId],
                                      backgroundColor: _tappedIndex == index
                                          ? darkGreen
                                          : Colors.white,
                                      textColor: _tappedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                      taskNumber: index + 1,
                                      checkIconColor: _tappedIndex == index
                                          ? Colors.white
                                          : Colors.green,
                                      isPostOwner: getEvent(snapshot).createdBy!
                                          .userId ==
                                          authProvider.currentUser.userId
                                          ? true
                                          : false,
                                      isCompleted:
                                      getEvent(snapshot).tasks[index]
                                      [Strings.dbTaskStatus] ==
                                          Strings.pending
                                          ? false
                                          : true,
                                    ));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customText(
                              getEvent(snapshot).tasks[_tappedIndex]
                              [Strings.dbTaskDescription],
                              Colors.black,
                              FontSize.smallFont,
                              FontWeight.normal),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FeedbackScreen(
                                            eventId: widget.eventId,)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: darkGreen,
                                  borderRadius: BorderRadius.circular(4)),
                              margin: const EdgeInsets.only(top: 15),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: customText('See Feedback', Colors.white,
                                  FontSize.smallFont, FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
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

  void joinEvent(EventProvider eventProvider, AuthProvider authProvider,
      Event event) async {
    if (int.parse(event.peopleNeed) > event.members.length) {
      await eventProvider.joinEvent(event.eventId, authProvider);
    } else {
      toast(Strings.eventHouseFul);
    }
  }

  void appreciateEvent(EventProvider eventProvider, AuthProvider authProvider,
      Event event) async {
    if (!hasAppreciated(event, authProvider)) {
      await eventProvider.appreciateEvent(widget.eventId, authProvider);
    } else {
      await eventProvider.depreciateEvent(widget.eventId, authProvider);
    }
  }

  int getCompletedTaskNumber(Event event) {
    return event.tasks
        .where((element) => element[Strings.dbTaskStatus] == Strings.completed)
        .toList()
        .length;
  }
}
