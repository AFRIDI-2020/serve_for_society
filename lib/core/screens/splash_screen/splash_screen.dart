import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
      checkAuthentication();
    });
  }

  checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(Strings.dbUserId);
    if(userId == null){
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }else{
      Navigator.pushNamedAndRemoveUntil(context, '/home_page', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                appThemeColor, darkGreen
              ]
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/volunteering.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(height: 20,),
              customText(Strings.appName.toUpperCase(), whiteTextColor, FontSize.xxLargeFont, FontWeight.bold)
            ],
          ),
        ),
      ),
    );
  }
}
