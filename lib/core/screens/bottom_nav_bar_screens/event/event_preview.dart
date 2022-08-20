import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/show_toast.dart';
import 'package:volunteer_project/core/models/event.dart';
import 'package:volunteer_project/core/models/event_creator.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/event/event_details.dart';
import 'package:volunteer_project/core/screens/comments/comment_screen.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class EventPreview extends StatefulWidget {
  final String eventId;

  const EventPreview({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventPreview> createState() => _EventPreviewState();
}

class _EventPreviewState extends State<EventPreview> {
  bool loading = false;
  bool appreciated = false;
  int totalAppreciation = 0;
  int totalMembers = 0;
  int totalComment = 0;


  bool isMember(Event event, AuthProvider authProvider){
    bool isMember = false;
    for(var member in event.members){
      if(member[Strings.dbUserId] == authProvider.currentUser.userId){
        isMember = true;
        break;
      }
    }
    return isMember;
  }

  bool hasAppreciated(Event event, AuthProvider authProvider){
    bool hasAppreciated = false;
    for(var appreciation in event.appreciation){
      if(appreciation[Strings.dbUserId] == authProvider.currentUser.userId){
        hasAppreciated = true;
        break;
      }
    }
    return hasAppreciated;
  }

  @override
  void initState() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    getNoOfComment(eventProvider);
    super.initState();
  }

  getNoOfComment(EventProvider eventProvider) async {
    totalComment =  await eventProvider.noOfComment(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('events').doc(widget.eventId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(!snapshot.hasData){
          return const SizedBox();
        }
        return Material(
          color: screenBgColor,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetails(eventId: widget.eventId)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      getEvent(snapshot).image != ''
                          ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        child: CachedNetworkImage(
                          imageUrl: getEvent(snapshot).image,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
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

                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                appreciateEvent(eventProvider, authProvider, getEvent(snapshot));
                              },
                              child: Icon(
                                hasAppreciated(getEvent(snapshot), authProvider)? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                color: Colors.green.shade900,
                              ),
                            ),
                            const SizedBox(width: 4,),
                            customText(getEvent(snapshot).appreciation.length.toString(), Colors.black,
                                FontSize.mediumFont, FontWeight.normal),

                            const SizedBox(width: 15,),
                            InkWell(
                              onTap: () async {
                                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(eventId: widget.eventId,)));
                                setState(() {
                                  totalComment = result;
                                });
                              },
                              child: Icon(
                                Icons.textsms_outlined,
                                color: Colors.green.shade900,
                              ),
                            ),
                            const SizedBox(width: 4,),
                            customText(totalComment.toString(), Colors.black,
                                FontSize.mediumFont, FontWeight.normal),

                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                  getEvent(snapshot).createdBy!.profileImage != ''
                                      ? CachedNetworkImageProvider(
                                      getEvent(snapshot).createdBy!.profileImage)
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
                                          DateFormat("dd MMM yyyy").add_jm().format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  int.parse(
                                                      getEvent(snapshot).createdAt))),
                                          Colors.black,
                                          FontSize.smallFont,
                                          FontWeight.normal),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.people,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    customText(
                                        '${getEvent(snapshot).members.length} / ${getEvent(snapshot).peopleNeed}',
                                        Colors.black,
                                        FontSize.smallFont,
                                        FontWeight.normal)
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            customText(
                                getEvent(snapshot).description.length > 200
                                    ? getEvent(snapshot).description.substring(0, 200) +
                                    '...'
                                    : getEvent(snapshot).description,
                                Colors.black,
                                FontSize.smallFont,
                                FontWeight.normal),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      customText(getEvent(snapshot).address, Colors.black,
                                          FontSize.smallFont, FontWeight.normal)
                                    ],
                                  ),
                                ),
                                isMember(getEvent(snapshot),authProvider)
                                    ? customText('Joined', darkGreen,
                                    FontSize.mediumFont, FontWeight.bold)
                                    : loading
                                    ? const CircularProgressIndicator()
                                    : SizedBox(
                                  width: 60,
                                  height: 24,
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side:
                                        BorderSide(color: darkGreen),
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        joinEvent(
                                            eventProvider, authProvider, getEvent(snapshot));
                                      },
                                      child: customText(
                                          'Join',
                                          darkGreen,
                                          FontSize.mediumFont,
                                          FontWeight.w500)),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void joinEvent(EventProvider eventProvider, AuthProvider authProvider, Event event) async {
    if(int.parse(event.peopleNeed) > event.members.length){
      await eventProvider.joinEvent(event.eventId, authProvider);
    }else{
      toast(Strings.eventHouseFul);
    }
  }

  void appreciateEvent(EventProvider eventProvider, AuthProvider authProvider, Event event) async{
    if(!hasAppreciated(event, authProvider)){
      await eventProvider.appreciateEvent(widget.eventId, authProvider);
    } else{
      await eventProvider.depreciateEvent(widget.eventId, authProvider);
    }
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
        profileImage: snapshot.data![Strings.dbCreatedBy][Strings.dbProfileImage],
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

}
