import 'package:flutter/material.dart';
import 'package:volunteer_project/utils/theme.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.width * .50,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'PASSWORD',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'UPDATED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.width * .04,
              ),
              Icon(
                Icons.check_circle,
                size: size.height * .35,
                color: darkGreen,
              ),
              SizedBox(
                height: size.width * .05,
              ),
              const Text('Your Password has been updated'),
              SizedBox(
                height: size.width * .15,
              ),
              Container(
                width: size.width,
                height: size.width * .14,
                padding: EdgeInsets.fromLTRB(
                    size.width * .06, 0.0, size.width * .06, 0.0),
                child: ElevatedButton(
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreen),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * .04),
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
