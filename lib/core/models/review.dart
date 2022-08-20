import 'package:volunteer_project/core/models/event_creator.dart';

class Review {
  String reviewId;
  String reviewMessage;
  String date;
  double rating;
  EventCreator? createdBy;

  Review(
      {this.reviewId = '', this.reviewMessage = '', this.date = '', this.rating = 0,
        this.createdBy});
}