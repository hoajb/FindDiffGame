import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'circle_checked.dart';
import 'game_data.dart';
import 'settings.dart';
import 'start_display.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //Main Page Game
//  List<GameData> _listMainGameData = new List();
  int _currentGameImage = 0;

  //Current Game Image Info

  int _checkedCount;
  GameState _gameState;
  List<Widget> _listChecked = new List();
  List<Widget> _listHintChecked = new List();

  Widget _hintWidget = Container();

  Timer _timeHelper;
  int _timeCountDown;

  GameData _gameData;

  @override
  void initState() {
    super.initState();
    _initMainGame();
  }

  void _initMainGame() {
//    var random = Random.secure();
//    for (int i = 0; i < 10; i++) {
//      _listMainGameData.add(GameData.fakeImage(random.nextInt(5) + 1)); //1->6
//      print("_initMainGame : ${_listMainGameData[i]}");
//    }

//    for (int i = 0; i < 6; i++) {
//      _listMainGameData.add(GameData.fakeImage(i + 1)); //1->6
//      print("_initMainGame : ${_listMainGameData[i]}");
//    }
    _currentGameImage = 0;
    _resetGameState();
  }

  void _resetGameState() {
    _gameState = GameState.STATE_IDE;
    _checkedCount = 0;
//    _gameData = _listMainGameData[_currentGameImage];
    _gameData = GameData.fakeImage(_currentGameImage);

    _listChecked.clear();
    _listHintChecked.clear();

    _hintWidget = Container();

    _timeCountDown = TIME_COUNT;

    //update hint
    _listHintCheckedWidget();
  }

  void _nextGameImage() {
//    _currentGameImage = Random.secure().nextInt(_listMainGameData.length);
    _currentGameImage = Random.secure().nextInt(5) + 1;

    print("_currentGameImage : $_currentGameImage");

    _resetGameState();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timeHelper = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timeCountDown < 1) {
            timer.cancel();

            _showPopupTimeOut();
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
      double _posx = localOffset.dx - CIRCLE_CHECK_SIZE / 2;
      double _posy = localOffset.dy - CIRCLE_CHECK_SIZE / 2;

      if (_gameData.isTouchInRect(Rect(_posx, _posy)))
        _addCheckedWidget(_posx, _posy);
      else
        _showToast("Failed");
    } else {
      _showToast("Click Play to Start");
    }
  }

  void _addCheckedWidget(double posx, double posy) {
    _clearHint();
    if (_checkedCount < NUM_DIFF) {
      setState(() {
        _listChecked.add(Positioned(
          child: CircleChecked(),
          left: posx,
          top: posy,
        ));
        _checkedCount++;

        if (_checkedCount == NUM_DIFF) {
          _showPopupNextGame();
          _timeHelper.cancel();
        }
      });
    }
  }

  void _listHintCheckedWidget() {
    for (Rect rect in _gameData.listRect) {
      print("listRect : $rect");
      _listHintChecked.add(Positioned(
        child: CircleHintChecked(Colors.blue),
        left: rect.x,
        top: rect.y,
      ));
    }
  }

  void _makeHint(Rect rect) {
    _hintWidget = Positioned(
      child: CircleHintChecked(Colors.lightGreenAccent),
      left: rect.x,
      top: rect.y,
    );
  }

  void _clearHint() {
    _hintWidget = Container();
  }

  bool _isPlaying() {
    return _gameState == GameState.STATE_PLAYING;
  }

  bool _isStop() {
    return _gameState == GameState.STATE_STOP;
  }

  bool _isIDE() {
    return _gameState == GameState.STATE_IDE;
  }

  void _showToast(String mess) {
    print('$mess');
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    _timeHelper.cancel();
    super.dispose();
  }

  Widget _createGroupImage(String path) {
    if (_isIDE()) return Container();

    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) => _onTapDown(context, details),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset(path),
          _isPlaying()
              ? Stack(fit: StackFit.expand, children: _listHintChecked)
              : Container(),
          _isPlaying()
              ? Stack(fit: StackFit.expand, children: _listChecked)
              : Container(),
          _hintWidget,
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

  Future<void> _showPopupNextGame() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bravo"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Well Play. You're smart"),
//                Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Next'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _nextGameImage();

                  _gameState = GameState.STATE_PLAYING;
                  _startTimer();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPopupTimeOut() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hic Hic"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Time Out. Try again?"),
//                Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _resetGameState();

                  _gameState = GameState.STATE_PLAYING;
                  _startTimer();
                });
              },
            ),
          ],
        );
      },
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

                            _startTimer();
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
                      onPressed: () {
                        _makeHint(_gameData.getFirstUncheckedRect());
                      },
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
          _createGroupImage(_gameData.urlA),
          SizedBox(
            height: 10,
          ),
          _createGroupImage(_gameData.urlB),
        ],
      ),
    );
  }
}
