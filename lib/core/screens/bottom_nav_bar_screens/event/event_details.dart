import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/dummy_text.dart';
import 'package:volunteer_project/core/components/task_card.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/event/event_members.dart';
import 'package:volunteer_project/core/screens/feedbacks/feedback_screen.dart';
import 'package:volunteer_project/utils/theme.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  int _tappedIndex = 0;
  final demoTaskList = [
    'Collecting old items and money from one\'s own area',
    'Sort out the most affected areas',
    'Dividing into two groups',
    'Distribution of relief',
    'Reporting to specific place and sharing experience and feelings'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyUI(),
    );
  }

  Widget _bodyUI() => Padding(
    padding: EdgeInsets.only(top: MediaQuery. of(context). padding. top),
    child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "https://storage.googleapis.com/afs-prod/media/b352d6662a55463e834d5d089b098d9e/3000.jpeg",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      height: 250,
                      fit: BoxFit.cover,
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
                              color: Colors.black45, shape: BoxShape.circle),
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
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black38,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 36,
                        child: customText('Tongi College Road, Tongi, Gazipur',
                            Colors.white, FontSize.smallFont, FontWeight.w500),
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
                          backgroundImage:
                              const AssetImage('assets/profile_image_demo.png'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText('Rober James', Colors.black,
                                  FontSize.mediumFont, FontWeight.bold),
                              const SizedBox(height: 3),
                              customText('March 18, 2022 6:45 pm', Colors.black,
                                  FontSize.smallFont, FontWeight.normal),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EventMembers()));
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
                                    child: customText('99', Colors.white,
                                        FontSize.xSmallFont, FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 24,
                          margin: const EdgeInsets.only(left: 20),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: darkGreen),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {},
                              child: customText('Join', darkGreen,
                                  FontSize.mediumFont, FontWeight.w500)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ExpandableText(
                      dummyText,
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.thumb_up,
                                        size: 20,
                                        color: darkGreen,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      customText('Appreciation ', Colors.black,
                                          FontSize.mediumFont, FontWeight.normal),
                                      customText('(24)', Colors.black,
                                          FontSize.smallFont, FontWeight.w500),
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
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     Icon(
                                        Icons.textsms_outlined,
                                        size: 20,
                                        color: darkGreen,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      customText('Comments ', Colors.black,
                                          FontSize.mediumFont, FontWeight.normal),
                                      customText('(11)', Colors.black,
                                          FontSize.smallFont, FontWeight.w500),
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
                    customText('Event Tasks (1/5)', Colors.black,
                        FontSize.mediumFont, FontWeight.w500),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  _tappedIndex = index;
                                });
                              },
                              child: TaskCard(
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
                                isCompleted: true,
                              ));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    customText(demoTaskList[_tappedIndex], Colors.black,
                        FontSize.largeFont, FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    customText(dummyText, Colors.black, FontSize.smallFont,
                        FontWeight.normal),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen()));
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
}
