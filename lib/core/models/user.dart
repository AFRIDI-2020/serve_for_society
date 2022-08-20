class User {
  String userId;
  String username;
  String password;
  String address;
  String mobileNo;
  String aboutUser;
  String profileImage;
  List<dynamic> completedEvents;
  List<dynamic> joinedEvents;

  User({
    this.userId = '',
    this.username = '',
    this.password = '',
    this.mobileNo = '',
    this.address = '',
    this.aboutUser = '',
    this.profileImage = '',
    this.joinedEvents = const [],
    this.completedEvents = const [],
  });
}
