import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_project/core/services/providers/auth_provider.dart';
import 'package:volunteer_project/utils/theme.dart';
import '../../models/user.dart';

class NumbersWidget extends StatelessWidget {
  const NumbersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    User user = Provider.of<AuthProvider>(context).currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(context, user.joinedEvents.length.toString(), 'Joined'),
        buildDivider(),
        buildButton(context, user.completedEvents.length.toString(), 'Completed'),
        buildDivider(),
        buildButton(context, (user.joinedEvents.length - user.completedEvents.length).toString(), 'Pending'),
      ],
    );
  }
  Widget buildDivider() => const SizedBox(
    height: 24,
    child: VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      );
}