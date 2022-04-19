import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volunteer_project/core/screens/auth/confirm_password_screen.dart';
import 'package:volunteer_project/core/screens/auth/forgot_password_screen.dart';
import 'package:volunteer_project/core/screens/auth/login_screen.dart';
import 'package:volunteer_project/core/screens/auth/update_password_screen.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/event/event_details.dart';
import 'package:volunteer_project/core/screens/home_page.dart';
import 'package:volunteer_project/core/screens/profile/profile.dart';
import 'package:volunteer_project/utils/theme.dart';

void main() {
  const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volunteer app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/home_page': (context) => HomePage(
          pageIndex: 0,
        ),
        '/event_details': (context) => const EventDetails(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/confirm_password': (context) => const ConfirmPasswordScreen(),
        '/update_password': (context) => const UpdatePasswordScreen(),
        '/profile': (context) => const Profile(),
      },
    );
  }
}
