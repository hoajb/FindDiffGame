import 'package:flutter/material.dart';
import 'package:flutter_game_difference/game/settings.dart';

class CircleChecked extends StatefulWidget {
  @override
  _CircleCheckedState createState() => _CircleCheckedState();
}

class _CircleCheckedState extends State<CircleChecked> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle,
      color: Colors.deepOrange,
      size: CIRCLE_CHECK_SIZE,
    );
  }
}
