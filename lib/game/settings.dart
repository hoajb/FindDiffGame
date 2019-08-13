const double CIRCLE_CHECK_SIZE = 50.0;
const int NUM_DIFF = 5;
const int TIME_COUNT = 60;

const double BLUR_BACKGROUND = 5.0;

enum GameState {
  STATE_IDE,
  STATE_PLAYING,
  STATE_STOP,
  STATE_TIMEOUT,
}

String convertTime(int count) {
  final String minutesStr =
      ((count / 60) % 60).floor().toString().padLeft(2, '0');
  final String secondsStr = (count % 60).floor().toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}
