import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'circle_checked.dart';
import 'settings.dart';
import 'start_display.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  double posx = 0.0;
  double posy = 0.0;
  int _checkedCount = 0;
  GameState _gameState = GameState.STATE_IDE;
  List<Widget> _listChecked = new List();

  Timer _timeHelper;
  int _timeCountDown = TIME_COUNT;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timeHelper = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timeCountDown < 1) {
            timer.cancel();

            //TODO
          } else {
            _timeCountDown = _timeCountDown - 1;
          }
        },
      ),
    );
  }

  void _onTapDown(BuildContext context, TapDownDetails details) {
    if (_gameState == GameState.STATE_PLAYING) {
      print('${details.globalPosition}');
      final RenderBox box = context.findRenderObject();
      final Offset localOffset = box.globalToLocal(details.localPosition);
      posx = localOffset.dx - CIRCLE_CHECK_SIZE / 2;
      posy = localOffset.dy - CIRCLE_CHECK_SIZE / 2;

      _addCheckedWidget();
    }
  }

  void _addCheckedWidget() {
    if (_checkedCount < NUM_DIFF) {
      setState(() {
        _listChecked.add(Positioned(
          child: CircleChecked(),
          left: posx,
          top: posy,
        ));
        _checkedCount++;
      });
    }
  }

  bool _isPlaying() {
    return _gameState == GameState.STATE_PLAYING;
  }

  bool _isStop() {
    return _gameState == GameState.STATE_STOP;
  }

  void _clean() {
    _checkedCount = 0;
    _listChecked.clear();
  }

  @override
  void dispose() {
    _timeHelper.cancel();
    super.dispose();
  }

  Widget _createGroupImage(String path) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) => _onTapDown(context, details),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset(path),
          _isPlaying()
              ? Stack(fit: StackFit.expand, children: _listChecked)
              : Container(),
          _isStop()
              ? ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: BLUR_BACKGROUND, sigmaY: BLUR_BACKGROUND),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5)),
                      child: new Center(
                        child: new Text('Pause',
                            style: Theme.of(context).textTheme.display1),
                      ),
                    ),
                  ),
                )
              : Container(),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Diff Game"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() {
                          if (_gameState == GameState.STATE_IDE ||
                              _gameState == GameState.STATE_STOP) {
                            _gameState = GameState.STATE_PLAYING;

                            startTimer();
//                            _clean();
                          } else if (_isPlaying()) {
                            _gameState = GameState.STATE_STOP;
                            _timeHelper.cancel();
                          }
                        });
                      },
                      icon: Icon(
                        _isPlaying()
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: 32,
                      ),
                      label: Text(
                        _isPlaying() ? "Pause" : "Play",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
                Expanded(
                  child: Text(
                    convertTime(_timeCountDown),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.lightbulb_outline,
                        size: 32,
                      ),
                      label: Text(
                        "Hint",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconTheme(
              data: IconThemeData(
                color: Colors.amber,
                size: 36,
              ),
              child: StarDisplay(value: _checkedCount),
            ),
          ),
          _createGroupImage("images/Image3a.png"),
          SizedBox(
            height: 10,
          ),
          _createGroupImage("images/Image3b.png"),
        ],
      ),
    );
  }
}
