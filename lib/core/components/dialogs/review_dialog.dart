import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/utils/theme.dart';

void showReviewDialog(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              backgroundColor: Colors.green.shade50.withOpacity(0.95),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customText('Share Your Thoughts', Colors.black,
                      FontSize.largeFont, FontWeight.w500),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                children: [
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: FontSize.largeFont,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) =>  Icon(
                      Icons.star,
                      color: darkGreen,
                    ),
                    onRatingUpdate: (value) {
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts here...',
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: (){
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: darkGreen,
                          borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: customText('Submit', Colors.white,
                          FontSize.smallFont, FontWeight.normal),
                    ),
                  )
                ],
              ),
            );
          });
    },
  );
}