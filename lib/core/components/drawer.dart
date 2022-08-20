import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/models/user.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/utils/theme.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
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
                    authProvider.currentUser.profileImage != ''
                        ? NetworkImage(authProvider.currentUser.profileImage)
                        : const AssetImage('assets/profile_image_demo.png')
                    as ImageProvider,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      authProvider.currentUser.username,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.largeFont,
                          fontWeight: FontWeight.bold),
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
            onTap: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
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
            onTap: () {
              logout(authProvider, context);
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
  }
}


void logout(AuthProvider authProvider, context) async {
  await authProvider.logout();
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
