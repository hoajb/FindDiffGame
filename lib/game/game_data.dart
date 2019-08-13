import 'dart:math';

import 'settings.dart';

class GameData {
  String urlA = "";
  String urlB = "";
  List<Rect> listRect = List();

  bool isTouchInRect(Rect touch) {
    for (Rect rect in listRect) {
      if (!rect.checked &&
          rect.getRangeX(RANGE_TOUCH).inRange(touch.x) &&
          rect.getRangeY(RANGE_TOUCH).inRange(touch.y)) {
        rect.checked = true;
        return true;
      }
    }
    return false;
  }

  Rect getFirstUncheckedRect() {
    return listRect.firstWhere((rect) => !rect.checked, orElse: () => null);
  }

  GameData.fakeImage3() {
    urlA = 'images/Image3a.png';
    urlB = 'images/Image3b.png';
    listRect.add(Rect(10, 10));
    listRect.add(Rect(50, 50));
    listRect.add(Rect(200, 200));
    listRect.add(Rect(100, 200));
    listRect.add(Rect(50, 130));
  }
}

class Rect {
  bool checked = false;

  double x;
  double y;

  Range getRangeX(double num) {
    return Range(x - num, x + num);
  }

  Range getRangeY(double num) {
    return Range(max(y - num, 0), y + num);
  }

  Rect(this.x, this.y);
}

class Range {
  double min;
  double max;

  Range(this.min, this.max);

  bool inRange(double num) {
    return min <= num && num <= max;
  }
}
