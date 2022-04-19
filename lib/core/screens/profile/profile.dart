import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/dummy_text.dart';
import 'package:volunteer_project/core/screens/profile/numbers_widget.dart';
import 'package:volunteer_project/utils/theme.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back, color: Colors.black,)),
        actions: [
          IconButton(onPressed: (){
          }, icon: const Icon(
            Icons.edit,
            color: Colors.black,
          ),)
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                   CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const AssetImage('assets/profile_image_demo.png'),
                    radius: 50,
                  ),
                  Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () async {

                        },
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade700),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            )),
                      ))
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildName(),

          const SizedBox(height: 20),
          NumbersWidget(),
          const SizedBox(height: 30),
          buildAbout(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
    children:  [
      Text(
        'Rober James',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
      ),
      const SizedBox(height: 4),
      const Text(
        '01782349745',
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildAbout() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          dummyText,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}