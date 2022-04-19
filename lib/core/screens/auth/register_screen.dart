import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/TextFieldBuilder.dart';
import 'package:volunteer_project/core/components/TextFieldValidation.dart';
import 'package:volunteer_project/utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _mobileNoErrorText;
  String? _usernameErrorText;
  String? _addressErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: _bodyUI(context),
        physics: const ClampingScrollPhysics(),
      ),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width,
        height: size.height,
        child: Column(children: [
          Container(
            width: size.width,
            height: size.height * .2,
            padding: EdgeInsets.only(bottom: size.width * .05),
            decoration: BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.only(
                  // bottomLeft: Radius.circular(size.width * .1),
                  bottomRight: Radius.circular(size.width * .1),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Serve for Society',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * .1,
                      fontFamily: 'MateSC',
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(FontAwesomeIcons.paw,
                    //     size: size.width * .04, color: Colors.white),
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
          ),
          Container(
            width: size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                right: size.width * .05,
                top: size.width * .05,
                left: size.width * .05,
                bottom: size.width * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: size.width * .06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.width * .02,
                ),
                Text(
                  'Get resistered for better experience',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .032,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            padding:
                EdgeInsets.fromLTRB(size.width * .05, 0, size.width * .05, 0.0),
            child: TextFieldBuilder().showtextFormBuilder(
                context,
                'Username',
                Icons.person,
                _usernameController,
                _usernameErrorText,
                false,
                null),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.fromLTRB(
                size.width * .05, size.width * .04, size.width * .05, 0.0),
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
                size.width * .05, size.width * .04, size.width * .05, 0.0),
            child: TextFieldBuilder().showtextFormBuilder(
                context,
                'Address',
                Icons.location_city,
                _addressController,
                _addressErrorText,
                false,
                null),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.fromLTRB(
                size.width * .05, size.width * .04, size.width * .05, 0.0),
            child: TextFieldBuilder().showtextFormBuilder(
                context,
                'Password',
                Icons.vpn_key,
                _passwordController,
                _passwordErrorText,
                passwordObscureText,
                InkWell(
                    onTap: () {
                      setState(() {
                        passwordObscureText = !passwordObscureText;
                      });
                    },
                    child: Icon(
                      passwordObscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: darkGreen,
                    ))),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.fromLTRB(
                size.width * .05, size.width * .04, size.width * .05, 0.0),
            child: TextFieldBuilder().showtextFormBuilder(
                context,
                'Confirm Password',
                Icons.vpn_key,
                _confirmPasswordController,
                _confirmPasswordErrorText,
                confirmPasswordObscureText,
                InkWell(
                    onTap: () {
                      setState(() {
                        confirmPasswordObscureText =
                            !confirmPasswordObscureText;
                      });
                    },
                    child: Icon(
                      confirmPasswordObscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: darkGreen,
                    ))),
          ),
          Container(
            width: size.width,
            height: size.width * .18,
            padding: EdgeInsets.fromLTRB(
                size.width * .05, 20.0, size.width * .05, 0.0),
            child: ElevatedButton(
              onPressed: () {
                // setState(() {
                //   if (!TextFieldValidation()
                //       .usernameValidation(_usernameController.text)) {
                //     _usernameErrorText = 'Username is required!';
                //     return;
                //   } else {
                //     _usernameErrorText = null;
                //   }
                //   if (!TextFieldValidation()
                //       .mobileNoValidate(_mobileNoController.text)) {
                //     _mobileNoErrorText = 'Invalid mobile number!';
                //     return;
                //   } else {
                //     _mobileNoErrorText = null;
                //   }
                //   if (!TextFieldValidation()
                //       .addressValidation(_addressController.text)) {
                //     _addressErrorText = 'Address is required!';
                //     return;
                //   } else {
                //     _addressErrorText = null;
                //   }
                //   if (!TextFieldValidation()
                //       .passwordValidation(_passwordController.text)) {
                //     _passwordErrorText =
                //         'Password must be of at least 6 digits!';
                //     return;
                //   } else {
                //     _passwordErrorText = null;
                //   }
                //   if (_confirmPasswordController.text !=
                //       _passwordController.text) {
                //     _confirmPasswordErrorText = 'Passwords does not match!';
                //     return;
                //   } else {
                //     _confirmPasswordErrorText = null;
                //   }
                //   Navigator.pushNamed(context, '/home_page');
                // });
                Navigator.pushNamed(context, '/home_page');
              },
              child: Text(
                'REGISTER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(darkGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ))),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding:
                EdgeInsets.only(top: size.width * .05, bottom: size.width * .1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have account?',
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
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text(
                    'Get looged in',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: size.width * .038,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
