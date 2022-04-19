import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/utils/theme.dart';

Drawer customDrawer(context) => Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: darkGreen,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: circleAvaterBgColor,
                    backgroundImage:
                        const AssetImage('assets/profile_image_demo.png'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Rober James',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: FontSize.largeFont,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '01782349745',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            title: customText(
                'Profile', Colors.black, FontSize.mediumFont, FontWeight.w500),
            leading: const Icon(
              Icons.person_outline,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
          ),
          ListTile(
            onTap: () {},
            title: customText('Edit Profile', Colors.black, FontSize.mediumFont,
                FontWeight.w500),
            leading: const Icon(
              Icons.edit_outlined,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/confirm_password');
            },
            title: customText('Reset Password', Colors.black,
                FontSize.mediumFont, FontWeight.w500),
            leading: const Icon(
              Icons.vpn_key_outlined,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
          ),
          ListTile(
            onTap: () async {
              Navigator.pushNamed(context, '/');
            },
            title: customText(
                'Log out', Colors.black, FontSize.mediumFont, FontWeight.w500),
            leading: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
    );
