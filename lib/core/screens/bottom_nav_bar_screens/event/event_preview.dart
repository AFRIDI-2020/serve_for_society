import 'package:flutter/material.dart';
import 'package:volunteer_project/core/components/custom_text.dart';
import 'package:volunteer_project/core/components/dummy_text.dart';
import 'package:volunteer_project/utils/theme.dart';

class EventPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: screenBgColor,
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, '/event_details');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.network(
                      'https://storage.googleapis.com/afs-prod/media/b352d6662a55463e834d5d089b098d9e/3000.jpeg',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/profile_image_demo.png'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText('Rober James', Colors.black,
                                      FontSize.mediumFont, FontWeight.bold),
                                  const SizedBox(height: 3),
                                  customText('March 18, 2022 6:45 pm', Colors.black,
                                      FontSize.smallFont, FontWeight.normal),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                customText('2', Colors.black, FontSize.mediumFont,
                                    FontWeight.normal),
                                const SizedBox(width: 2,),
                                const Icon(
                                  Icons.textsms_outlined,
                                  color: Colors.grey,
                                ),

                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        customText(
                            dummyText.length > 200
                                ? dummyText.substring(0, 200) + '...'
                                : dummyText,
                            Colors.black,
                            FontSize.smallFont,
                            FontWeight.normal),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            customText('3 / 5', Colors.black, FontSize.smallFont,
                                FontWeight.normal)
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  customText(
                                      'Tongi College Road, Tongi, Gazipur',
                                      Colors.black,
                                      FontSize.smallFont,
                                      FontWeight.normal)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 24,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: darkGreen),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  child: customText('Join', darkGreen,
                                      FontSize.mediumFont, FontWeight.w500)),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
