import 'package:flutter/material.dart';
import 'package:volunteer_project/utils/theme.dart';

class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      buildButton(context, '5', 'Joined'),
      buildDivider(),
      buildButton(context, '3', 'Completed'),
      buildDivider(),
      buildButton(context, '2', 'Pending'),
    ],
  );
  Widget buildDivider() => Container(
    height: 24,
    child: VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color: darkGreen),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      );
}