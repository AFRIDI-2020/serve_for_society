import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/TextFieldBuilder.dart';
import 'package:volunteer_project/core/screens/auth/forgot_password_screen.dart';
import 'package:volunteer_project/core/screens/auth/register_screen.dart';
import 'package:volunteer_project/utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _mobileNoErrorText;
  String? _passwordErrorText;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Login',
        ),
      ),
      body: _bodyUI(context),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 30.0,
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: size.height * .15,
                  padding: EdgeInsets.only(bottom: size.width * .06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Serve for Society',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * .1,
                            fontFamily: 'Marion',
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: size.width * .03),
                          Text(
                            'One Step For Our Selves',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * .045,
                            ),
                          ),
                          SizedBox(width: size.width * .03),
                          // Icon(FontAwesomeIcons.paw,
                          //     size: size.width * .04, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: SizedBox(
              height: size.height * .70,
              width: size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size.width * .15),
                    // topLeft: Radius.circular(size.width * .15),
                  ),
                ),
                margin: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, size.width * .15, 0.0, 0.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: size.width * .06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, size.width * .02, 0.0, 0.0),
                      child: Text(
                        'Get logged in for better experience',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * .032,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, 20.0, size.width * .05, 0.0),
                      child: TextFieldBuilder().showtextFormBuilder(
                          context,
                          'Mobile number',
                          Icons.phone_android_outlined,
                          _mobileNoController,
                          _mobileNoErrorText,
                          false,
                          null),
                    ),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(
                          size.width * .05, 20.0, size.width * .05, 0.0),
                      child: TextFieldBuilder().showtextFormBuilder(
                          context,
                          'Password',
                          Icons.vpn_key,
                          _passwordController,
                          _passwordErrorText,
                          obscureText,
                          InkWell(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: darkGreen,
                              ))),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/home_page');
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: darkGreen
                        ),
                        margin: EdgeInsets.fromLTRB(
                            size.width * .05, 20.0, size.width * .05, 0.0),
                        alignment: Alignment.center,
                        child: Text(
                          'LOG IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * .04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: size.width * .04),
                        width: size.width,
                        child: TextButton(
                          child: Text(
                            'Forget password?',
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: size.width * .038,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot_password');
                          },
                        )),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          bottom: size.width * .1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Do not have account?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .038,
                              ),
                            ),
                            SizedBox(
                              width: size.width * .02,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen()));
                              },
                              child: Text(
                                'Register here',
                                style: TextStyle(
                                  color: darkGreen,
                                  fontSize: size.width * .038,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
