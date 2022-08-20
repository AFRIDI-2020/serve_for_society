import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/dummy_text.dart';
import 'package:volunteer_project/core/models/review.dart';
import 'package:volunteer_project/utils/theme.dart';

class FeedbackItem extends StatelessWidget {
  final Review review;

  const FeedbackItem({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String reviewTime = DateFormat.yMMMd().add_jm().format(
        DateTime.fromMillisecondsSinceEpoch(int.parse("1660276083033")));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               CircleAvatar(
                radius: 20,
                backgroundImage: review.createdBy!.profileImage != ''
                    ? CachedNetworkImageProvider(review.createdBy!.profileImage)
                    : const AssetImage('assets/profile_image_demo.png') as ImageProvider,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(review.createdBy!.username, Colors.white,
                        FontSize.mediumFont, FontWeight.w500),
                    const SizedBox(height: 3),
                    customText(reviewTime, Colors.grey.shade400,
                        FontSize.smallFont, FontWeight.normal),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ExpandableText(
            review.reviewMessage,
            expandText: 'show more',
            collapseText: 'show less',
            maxLines: 5,
            linkColor: Colors.green,
            style: TextStyle(color: Colors.grey.shade300),
          ),
          const SizedBox(height: 10),
          RatingBar(
            ignoreGestures: true,
            glowColor: Colors.white,
            unratedColor: Colors.grey,
            initialRating: review.rating,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: FontSize.smallFont,
            ratingWidget: RatingWidget(
              full: const Icon(
                Icons.star,
                color: Colors.white,
              ),
              half: const Icon(
                Icons.star_half,
                color: Colors.white,
              ),
              empty: const Icon(
                Icons.star_outline,
                color: Colors.white,
              ),
            ),
            onRatingUpdate: (double value) {},
          ),
        ],
      ),
    );
  }
}
