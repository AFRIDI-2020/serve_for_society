import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/components/custom_text_field.dart';
import 'package:volunteer_project/core/models/user.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressController = TextEditingController();
  final aboutUserController = TextEditingController();
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setPreviousUserDetails();
    });
  }

  Future pickImageFromGallery() async {
    final XFile? originalImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (originalImage != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: originalImage.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null) {
        setState(() {
          imageFile = File(croppedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: _bodyUI(context, authProvider),
    );
  }

  Widget _bodyUI(BuildContext context, AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [

            buildProfileImage(authProvider),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  CustomTextField(
                    labelText: Strings.username,
                    controller: usernameController,
                    enabled: false,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    labelText: Strings.mobileNumber,
                    controller: mobileNoController,
                    textInputType: TextInputType.phone,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    labelText: Strings.address,
                    controller: addressController,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    labelText: Strings.about,
                    controller: aboutUserController,
                    textInputType: TextInputType.multiline,
                    maxLine: 5,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write something about yourself';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              updateProfile(authProvider);
                            }
                          },
                          child: const Text(
                            Strings.saveChanges,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: FontSize.smallFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(darkGreen),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                        ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  void setPreviousUserDetails() {
    User user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    setState(() {
      usernameController.text = user.username;
      mobileNoController.text = user.mobileNo;
      addressController.text = user.address;
      aboutUserController.text = user.aboutUser == ""
          ? 'I am ${user.username}. I am ...'
          : user.aboutUser;
    });
  }

  void updateProfile(AuthProvider authProvider) async {
    setState(() {
      loading = true;
    });
    String? imageLink;
    if (imageFile != null) {
      imageLink = await authProvider.uploadProfileImage(imageFile!);
    }
    Map<String, String> userData = {
      Strings.dbMobileNo: mobileNoController.text,
      Strings.dbAddress: addressController.text,
      Strings.dbAboutUser: aboutUserController.text,
      Strings.dbProfileImage: imageLink ?? "",
    };
    bool isSuccessful = await authProvider.updateProfile(userData);
    setState(() {
      loading = false;
    });
    if (isSuccessful) {
      back();
    }
  }

  void back() {
    Navigator.pop(context);
  }

  buildProfileImage(AuthProvider authProvider) {
    User user = authProvider.currentUser;
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            backgroundImage: user.profileImage == '' && imageFile == null? const AssetImage('assets/profile_image_demo.png')  :
            imageFile != null
                ? FileImage(imageFile!)
                : NetworkImage(user.profileImage)
            as ImageProvider,
            radius: 70,
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  pickImageFromGallery();
                },
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 20,
                    )),
              ))
        ],
      ),
    );
  }
}
