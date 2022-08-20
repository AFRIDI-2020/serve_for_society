import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/dummy_text.dart';
import 'package:volunteer_project/core/screens/profile/numbers_widget.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import '../../models/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: authProvider.currentUser.profileImage != ''
                    ? NetworkImage(authProvider.currentUser.profileImage)
                    : const AssetImage('assets/profile_image_demo.png')
                        as ImageProvider,
                radius: 60,
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildName(),
          const SizedBox(height: 20),
          const NumbersWidget(),
          const SizedBox(height: 30),
          buildAbout(),
        ],
      ),
    );
  }

  Widget buildName() {
    User user = Provider.of<AuthProvider>(context).currentUser;
    return Column(
      children: [
        Text(
          user.username,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          user.mobileNo,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildAbout() {
    User user = Provider.of<AuthProvider>(context).currentUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.aboutUser == '' ? Strings.nothingAddedYet : user.aboutUser,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }
}
