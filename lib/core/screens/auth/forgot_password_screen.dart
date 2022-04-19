import 'package:flutter/material.dart';
import 'package:volunteer_project/utils/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: AppBar().preferredSize.height,
                color: Colors.white,
              ),
              Container(
                width: size.width,
                height: size.width * .45,
                color: Colors.white,
                child: Icon(
                  Icons.phonelink_lock_sharp,
                  size: size.width * .30,
                ),
              ),
              Container(
                width: size.width,
                height: size.width * .35,
                color: Colors.white,
                child: Column(
                  children: [
                    const Text(
                      'FORGET',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'PASSWORD',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * .02),
                      child: const Text(
                        'Provide your accounts phone number for which you want to reset your password!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: size.width,
                height: size.width * .17,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        size.width * .06,
                        0.0,
                        size.width * .06,
                        0.0,
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            size.width * .05,
                            size.width * .04,
                            size.width * .05,
                            0.0,
                          ),
                          prefixIcon: const Icon(
                            Icons.phone_android_outlined,
                          ),
                          labelText: 'Phone Number',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: darkGreen,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: size.width,
                height: size.width * .14,
                padding: EdgeInsets.fromLTRB(
                    size.width * .06, 0.0, size.width * .06, 0.0),
                child: ElevatedButton(
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/confirm_password');
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreen),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
