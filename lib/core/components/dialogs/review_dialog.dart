import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/core/services/providers/event_provider.dart';
import 'package:volunteer_project/utils/strings.dart';
import 'package:volunteer_project/utils/theme.dart';

void showReviewDialog(context, String eventId) {
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
          content: ReviewBuilder(
            eventId: eventId,
          ),
        );
      });
    },
  );
}

class ReviewBuilder extends StatefulWidget {
  final String eventId;

  const ReviewBuilder({Key? key, required this.eventId}) : super(key: key);

  @override
  _ReviewBuilderState createState() => _ReviewBuilderState();
}

class _ReviewBuilderState extends State<ReviewBuilder> {
  double rating = 0;
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: FontSize.largeFont,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: darkGreen,
            ),
            onRatingUpdate: (value) {
              setState(() {
                rating = value;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: messageController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            cursorColor: Colors.black,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Write your thoughts about the event';
              }
              return null;
            },
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
          loading
              ? const Center(child: CircularProgressIndicator())
              : InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      sendReviewBuilder(eventProvider, authProvider);
                    }
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
  }

  void sendReviewBuilder(
      EventProvider eventProvider, AuthProvider authProvider) async {
    String id = const Uuid().v4();
    Map<String, dynamic> data = {
      Strings.dbReviewId: id,
      Strings.dbRating: rating,
      Strings.dbDate: DateTime.now().millisecondsSinceEpoch.toString(),
      Strings.dbReviewMsg: messageController.text,
      Strings.dbCreatedBy: authProvider.getCreatedBy(authProvider.currentUser)
    };
    setState(() {
      loading = true;
    });

    await eventProvider.sendReview(widget.eventId, data, id);
    await eventProvider.getAllReviews(widget.eventId);
    clearFields();
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }

  void clearFields() {
    setState(() {
      messageController.clear();
      rating = 0;
    });
  }
}
