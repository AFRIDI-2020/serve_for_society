import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteer_project/core/components/show_toast.dart';
import 'package:volunteer_project/core/models/user.dart';
import 'package:volunteer_project/core/models/user_registration.dart';
import 'package:volunteer_project/utils/my_encryption.dart';
import 'package:volunteer_project/utils/strings.dart';

class AuthProvider extends ChangeNotifier {
  final String userCollection = 'users';
  User currentUser = User();


  Map<String, dynamic> getCreatedBy(User user){
    Map<String, dynamic> userMap = {
      Strings.dbUsername: user.username,
      Strings.dbMobileNo: user.mobileNo,
      Strings.dbAddress: user.address,
      Strings.dbUserId: user.userId,
      Strings.dbAboutUser: user.aboutUser,
      Strings.dbProfileImage: user.profileImage,
    };
    return userMap;
  }

  Future<void> registerUser(
      UserRegistration userRegistrationModel, context) async {
    String userId = const Uuid().v4();
    final prefs = await SharedPreferences.getInstance();
    try {
      FirebaseFirestore.instance.collection(userCollection).doc(userId).set({
        Strings.dbUsername: userRegistrationModel.username,
        Strings.dbMobileNo: userRegistrationModel.mobileNo,
        Strings.dbAddress: userRegistrationModel.address,
        Strings.dbPassword: userRegistrationModel.password,
        Strings.dbUserId: userId,
        Strings.dbAboutUser: '',
        Strings.dbProfileImage: '',
        Strings.dbJoinedEvents: [],
        Strings.dbCompletedEvents: []
      }).then((value) {
        toast(Strings.registrationSuccessful);
        prefs.setString(Strings.dbUserId, userId);
        Navigator.pushNamedAndRemoveUntil(
            context, '/home_page', (route) => false);
      }).catchError((error) {
        toast(Strings.somethingWentWrong);
        log("registration failed, error - $error");
      });
    } on SocketException {
      toast(Strings.noInternetConnection);
    } catch (e) {
      log('registration failed, error - $e');
    }
  }

  Future<void> login(String username, String password, context) async {
    bool isSuccessful = false;
    final prefs = await SharedPreferences.getInstance();
    try {
      await FirebaseFirestore.instance
          .collection(userCollection)
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docChanges) {
          log(element.doc[Strings.dbUsername]);
          if (element.doc[Strings.dbUsername] == username) {
            if (element.doc[Strings.dbPassword] ==
                TextEncryption().encodeText(password)) {
              isSuccessful = true;
              prefs.setString(Strings.dbUserId, element.doc[Strings.dbUserId]);
              break;
            }
          }
        }
      });

      if (isSuccessful) {
        toast(Strings.loginSuccessful);
        Navigator.pushNamedAndRemoveUntil(
            context, '/home_page', (route) => false);
      } else {
        toast(Strings.invalidUsernamePassword);
      }
      notifyListeners();
    } on SocketException {
      toast(Strings.noInternetConnection);
    } catch (e) {
      log('login failed, error - $e');
    }
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Strings.dbUserId);
    log(Strings.logout);
    notifyListeners();
  }

  Future<void> getCurrentUserDetails(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(id)
          .get()
          .then((documentSnapshot) {
        currentUser = User(
            userId: documentSnapshot[Strings.dbUserId],
            username: documentSnapshot[Strings.dbUsername],
            password: documentSnapshot[Strings.dbPassword],
            address: documentSnapshot[Strings.dbAddress],
            mobileNo: documentSnapshot[Strings.dbMobileNo],
            aboutUser: documentSnapshot[Strings.dbAboutUser],
            profileImage: documentSnapshot[Strings.dbProfileImage],
            completedEvents: documentSnapshot[Strings.dbCompletedEvents],
            joinedEvents: documentSnapshot[Strings.dbJoinedEvents]);
      });
      notifyListeners();
    } on SocketException {
      toast(Strings.noInternetConnection);
    } catch (e) {
      log('Fetching user details failed, error - $e');
    }
  }

  Future<String?> uploadProfileImage(File? file) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(currentUser.userId);

    if (file != null) {
      UploadTask uploadTask = ref.putFile(File(file.path));
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    }
    return null;
  }

  Future <bool> updateProfile(Map<String, String> userData) async {
    bool isSuccessful = false;
    try {
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(currentUser.userId)
          .update(userData)
          .then((value) async {
        getCurrentUserDetails(currentUser.userId);
        toast(Strings.profileUpdateSuccess);
        isSuccessful = true;
      }).catchError((e) {
        toast(Strings.somethingWentWrong);
        log('profile update failed, error - $e');
        isSuccessful = false;
      });
      return isSuccessful;
    } on SocketException {
      toast(Strings.noInternetConnection);
      return false;
    } catch (e) {
      log('updating user profile failed, error - $e');
      return false;
    }
  }
}
