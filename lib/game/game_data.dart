import 'dart:math';

import 'settings.dart';

class GameData {
  String urlA = "";
  String urlB = "";
  List<Rect> listRect = List();

  @override
  String toString() {
    String rRect = "";
    for (Rect rect in listRect) {
      rRect += '\n';
      rRect += rect.toString();
    }
    rRect += '\n';
    return "GameData{$urlA,$urlB,$rRect}";
  }

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

    var random = Random.secure();
    for (int i = 0; i < 5; i++) {
      listRect.add(
          Rect(random.nextInt(300).toDouble(), random.nextInt(200).toDouble()));
    }
  }

  GameData.fakeImage(int numFile) {
    urlA = 'images/Image${numFile}a.png';
    urlB = 'images/Image${numFile}b.png';

    var random = Random.secure();
    for (int i = 0; i < 5; i++) {
      listRect.add(
          Rect(random.nextInt(300).toDouble(), random.nextInt(200).toDouble()));
    }
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

  @override
  String toString() {
    return "Rect[$x,$y]";
  }
}

class Range {
  double min;
  double max;

  Range(this.min, this.max);

  bool inRange(double num) {
    return min <= num && num <= max;
  }
}
