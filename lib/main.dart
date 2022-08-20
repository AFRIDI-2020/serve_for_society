import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/screens/auth/confirm_password_screen.dart';
import 'package:volunteer_project/core/screens/auth/forgot_password_screen.dart';
import 'package:volunteer_project/core/screens/auth/login_screen.dart';
import 'package:volunteer_project/core/screens/auth/update_password_screen.dart';
import 'package:volunteer_project/core/screens/bottom_nav_bar_screens/event/event_details.dart';
import 'package:volunteer_project/core/screens/home_page.dart';
import 'package:volunteer_project/core/screens/profile/edit_profile.dart';
import 'package:volunteer_project/core/screens/profile/profile.dart';
import 'package:volunteer_project/core/screens/splash_screen/splash_screen.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/chat_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.dark,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Volunteer app',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/home_page': (context) => const HomePage(
                pageIndex: 0,
              ),
          '/forgot_password': (context) => const ForgotPasswordScreen(),
          '/confirm_password': (context) => const ConfirmPasswordScreen(),
          '/update_password': (context) => const UpdatePasswordScreen(),
          '/profile': (context) => const Profile(),
          '/login': (context) => const LoginScreen(),
          '/splash_screen': (context) => const SplashScreen(),
          '/edit_profile': (context) => const EditProfile(),
        },
      ),
    );
  }
}
