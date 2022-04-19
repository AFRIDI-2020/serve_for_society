import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({Key? key}) : super(key: key);

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () async {
                Navigator.pop(context, true);
              }),
          toolbarHeight: size.height * .08,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                radius: size.width * .05,
              ),
              SizedBox(width: 15),
              Text("ABC chowdhury", style: TextStyle(color: Colors.black))
            ],
          )),
      body: Stack(
        children: [
          _bodyUi(),
          _isLoading ? Center(child: CircularProgressIndicator()) : Container()
        ],
      ),
    );
  }

  Widget _bodyUi() {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.all(size.width * .05),
              child: Column(
                children: [
                  _message(size, "hi", "hello"),
                  _message(size, "how are you?", "i am fine, what about you"),
                  _message(size, "i am also fine", "okay bye"),
                ],
              )),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
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
                    child: Container(
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
                  ),
                  SizedBox(
                    width: size.width * .04,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.width * .04),
                    child: IconButton(
                      onPressed: () {},
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
      ),
    );
  }

  Widget _message(Size size, String a, String b) => Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(
                    'https://in.bmscdn.com/iedb/artist/images/website/poster/large/gal-gadot-11088-17-10-2017-11-45-36.jpg'),
                radius: size.width * .06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.8),
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      size.width * .03,
                    ),
                        topRight: Radius.circular(size.width*.03,)
                  )),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .03, vertical: size.width * .03),
                  child: Text(
                    a,
                    style: TextStyle(
                        color: Colors.white, fontSize: size.width * .04),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: size.width * .04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            size.width * .03,
                          ),
                          bottomRight: Radius.circular(size.width*.03,)
                      )),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .03, vertical: size.width * .03),
                  child: Text(
                    a,
                    style: TextStyle(
                        color: Colors.black, fontSize: size.width * .04),
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                radius: size.width * .06,
              ),
            ],
          ),
          SizedBox(
            height: size.width * .04,
          ),
        ],
      );
}
