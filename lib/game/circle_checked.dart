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

class CircleHintChecked extends StatefulWidget {
  Color color;

  CircleHintChecked(this.color);

  @override
  _CircleHintCheckedState createState() => _CircleHintCheckedState(this.color);
}

class _CircleHintCheckedState extends State<CircleHintChecked> {
  Color color;

  _CircleHintCheckedState(this.color);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle_outline,
      color: color,
      size: CIRCLE_CHECK_SIZE,
    );
  }
}
