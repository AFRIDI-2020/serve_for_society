import 'package:flutter/material.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/chat/chatting_screen.dart';

class ChatNavScr extends StatefulWidget {
  const ChatNavScr({Key? key}) : super(key: key);

  @override
  State<ChatNavScr> createState() => _ChatNavScrState();
}

class _ChatNavScrState extends State<ChatNavScr> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _bodyUI(context),
        physics: ClampingScrollPhysics(),
      ),
      // body: _bodyUI(context),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
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
                    Icon(
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
                          EdgeInsets.only(top: .02, bottom: .02),
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
          Container(
              width: size.width,
              child: Column(
                children: [
                  _messageUI(context),
                  _messageUI(context),
                  _messageUI(context),
                  _messageUI(context),
                  _messageUI(context),
                  _messageUI(context),
                  _messageUI(context),

                ],
              ))
        ],
      ),
    );
  }

  Widget _messageUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingScreen()));
      },
      child: Container(
        width: size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(size.width * .03, size.width * .02,
              size.width * .02, size.width * .02),
          child: Row(

            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage('https://in.bmscdn.com/iedb/artist/images/website/poster/large/gal-gadot-11088-17-10-2017-11-45-36.jpg'),
                radius: size.width * .06,
              ),
              Container(
                width: size.width * .8,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(size.width * .03, size.width * .02,
                      size.width * .02, size.width * .02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * .7,
                        child: Text(
                          'Gal Gadot',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                          width: size.width * .7,
                          child: Text(
                            'What\'s up? How are you?',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ))
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
