import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/models/group.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/chat/chatting_screen.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';

class ChatNavScr extends StatefulWidget {
  const ChatNavScr({Key? key}) : super(key: key);

  @override
  State<ChatNavScr> createState() => _ChatNavScrState();
}

class _ChatNavScrState extends State<ChatNavScr> {
  final TextEditingController _searchController = TextEditingController();
  List<Group> chats = [];
  bool loading = false;

  @override
  void initState() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    getAllChats(eventProvider, authProvider);
    super.initState();
  }

  getAllChats(EventProvider eventProvider, AuthProvider authProvider) async {
    setState(() {
      loading = true;
    });
    chats = await eventProvider.getAllChats(authProvider);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: loading? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(size.width * .04, size.width * .03,
                    size.width * .04, size.width * .03),
                child: Container(
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(size.width * .025,
                        size.width * .025, size.width * .02, size.width * .025),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: size.width * .02,
                        ),
                        Container(
                          width: size.width * .7,
                          child: TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.only(top: .02, bottom: .02),
                              hintText: 'Search',
                              hintStyle: TextStyle(fontSize: size.width * .038),
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            cursorColor: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(size.width * .04)),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: chats.length,
                itemBuilder: (context, index){
                  return _messageUI(chats[index]);
                },
              )
            ],
          ),
        )
      ),
      // body: _bodyUI(context),
    );
  }


  Widget _messageUI(Group group) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingScreen(group: group,)));
      },
      child: SizedBox(
        width: size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(size.width * .03, size.width * .02,
              size.width * .02, size.width * .02),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: size.width * .06,
                backgroundImage: group.groupImage != ''? CachedNetworkImageProvider(group.groupImage) : const AssetImage("assets/ic_group.png") as ImageProvider,
              ),
              SizedBox(
                width: size.width * .8,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(size.width * .03, size.width * .02,
                      size.width * .02, size.width * .02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * .7,
                        child: Text(
                          group.groupName,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Tap to chat...',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
