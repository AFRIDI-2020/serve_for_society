import 'package:volunteer_project/core/models/event_creator.dart';
import 'package:volunteer_project/core/models/user.dart';

class Event {
  String address;
  String createdAt;
  EventCreator? createdBy;
  String description;
  String eventId;
  String image;
  String peopleNeed;
  List<dynamic> tasks;
  List<dynamic> members;
  List<dynamic> appreciation;

  Event({this.eventId = '',
    this.createdAt = '',
    this.createdBy,
    this.description = '',
    this.image = '',
    this.peopleNeed = '',
    this.tasks = const [],
    this.members = const [],
    this.address = '',
    this.appreciation = const []
  });
}
