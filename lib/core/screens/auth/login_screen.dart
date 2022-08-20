import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/TextFieldBuilder.dart';
import 'package:volunteer_project/core/components/TextFieldValidation.dart';
import 'package:volunteer_project/core/screens/auth/register_screen.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _mobileNoErrorText;
  String? _passwordErrorText;
  bool obscureText = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          Strings.login,
        ),
      ),
      body: _bodyUI(context, authProvider),
    );
  }

  Widget _bodyUI(BuildContext context, AuthProvider authProvider) {
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
                        Strings.serveForSociety,
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
                            Strings.oneStepForOurSociety,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * .045,
                            ),
                          ),
                          SizedBox(width: size.width * .03)
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
                        Strings.login,
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
                        Strings.loginScreenSubTitle,
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
                          Strings.username,
                          Icons.person,
                          usernameController,
                          _mobileNoErrorText,
                          false,
                          null,
                          textInputType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z.A-Z0-9_-]")),
                          ]),
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
                              )),
                          textInputType: TextInputType.visiblePassword),
                    ),
                    loading
                        ? const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(child: CircularProgressIndicator()),
                        )
                        : InkWell(
                            onTap: () {
                              login(authProvider);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: darkGreen),
                              margin: EdgeInsets.fromLTRB(size.width * .05,
                                  20.0, size.width * .05, 0.0),
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

  void login(AuthProvider authProvider) async {
    if (!TextFieldValidation().usernameValidation(usernameController.text)) {
      setState(() {
        _mobileNoErrorText = Strings.usernameRequired;
      });
      return;
    } else {
      setState(() {
        _mobileNoErrorText = null;
      });
    }
    if (!TextFieldValidation().passwordValidation(_passwordController.text)) {
      setState(() {
        _passwordErrorText = 'Password must be of at least 6 digits!';
      });
      return;
    } else {
      setState(() {
        _passwordErrorText = null;
      });
    }
    setState(() {
      loading = true;
    });
    await authProvider.login(
        usernameController.text, _passwordController.text, context);
    setState(() {
      loading = false;
    });
  }
}
