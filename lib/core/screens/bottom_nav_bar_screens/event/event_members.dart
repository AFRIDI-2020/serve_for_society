import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class EventMembers extends StatefulWidget {
  final List<dynamic> members;

  const EventMembers({Key? key, required this.members}) : super(key: key);

  @override
  _EventMembersState createState() => _EventMembersState();
}

class _EventMembersState extends State<EventMembers> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: customText(
            'Event Members', Colors.black, FontSize.largeFont, FontWeight.w500),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //searchMemberField(context),
          SizedBox(
            height: size.width * .03,
          ),
          Padding(
            padding: EdgeInsets.only(left: size.width * .04),
            child: customText(
                'Members', Colors.black, FontSize.mediumFont, FontWeight.w500),
          ),
          SizedBox(
            height: size.width * .03,
          ),
          SizedBox(
            width: size.width,
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    leading: CircleAvatar(
                      backgroundColor: circleAvaterBgColor,
                      radius: 20,
                      backgroundImage: widget.members[index][Strings.dbProfileImage] ==
                              ''
                          ? const AssetImage('assets/profile_image_demo.png')
                          : CachedNetworkImageProvider(widget.members[index][Strings.dbProfileImage])
                              as ImageProvider,
                    ),
                    title: customText(widget.members[index][Strings.dbUsername], Colors.black,
                        FontSize.mediumFont, FontWeight.w500),
                    trailing: customText(
                        index == 0 ? '(Host)' : '(member)',
                        index == 0 ? Colors.green : Colors.black,
                        FontSize.smallFont,
                        FontWeight.w500),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget searchMemberField(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width * .04, size.width * .04,
          size.width * .04, size.width * .02),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              padding: EdgeInsets.fromLTRB(
                  0, size.width * .02, size.width * .02, size.width * .02),
              child: TextFormField(
                //onChanged: _searchMember,
                cursorColor: Colors.black,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search member',
                  hintStyle: const TextStyle(color: Colors.black),
                  isDense: true,
                  contentPadding: EdgeInsets.only(left: size.width * .04),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
