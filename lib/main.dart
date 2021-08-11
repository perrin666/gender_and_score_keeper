import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gender_and_score_keeper/clock_widget.dart';

import 'model/match_model.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MatchModel()),
      ],
      child: MaterialApp(
        title: 'Mixed Score Keeper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Mixed Score Keeper'),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String RESET_BUTTON = 'RESET_BUTTON';
  static const String CONFIG_BUTTON = 'CONFIG_BUTTON';

  bool _started = false;

  late TextEditingController _messagingController;

  late MatchModel _model;

  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    _model = Provider.of(context);

    _messagingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: CONFIG_BUTTON,
                  child: Text('Configure game'),
                ),
                PopupMenuItem<String>(
                  value: RESET_BUTTON,
                  child: Text('Reset game'),
                ),
              ];
            },
            onSelected: (value) => {
              if (value == RESET_BUTTON)
                {
                  setState(() {
                    _model.awayTeam = 0;
                    _model.homeTeam = 0;

                    _model.gameMinutes = _model.gameTime;
                    _model.gameSeconds = 0;

                    _model.halftimeMinutes = (_model.gameTime / 2).floor();
                    if (_model.halftimeMinutes * 2 == _model.gameTime - 1) {
                      _model.halftimeSeconds = 30;
                    } else {
                      _model.halftimeSeconds = 0;
                    }

                    _started = false;
                  })
                }
              else if (value == CONFIG_BUTTON)
                {_showConfigPopup()}
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClockWidget(),
            Text('Halftime:'),
            ClockWidget(
              halfTimeClock: true,
              large: false,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                'Score:',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    if (_model.homeTeam > 0) _model.homeTeam--;
                  },
                  child: Text('-'),
                ),
                TextButton(
                  onPressed: () {
                    _model.homeTeam++;
                  },
                  child: Text('+'),
                ),
                Text(
                  _model.score,
                  style: Theme.of(context).textTheme.headline2,
                ),
                TextButton(
                  onPressed: () {
                    if (_model.awayTeam > 0) _model.awayTeam--;
                  },
                  child: Text('-'),
                ),
                TextButton(
                  onPressed: () {
                    _model.awayTeam++;
                  },
                  child: Text('+'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      (_model.homeTeam + _model.awayTeam) % 4 == 0 ? _gender(true) : 'A',
                      style: (_model.homeTeam + _model.awayTeam) % 4 == 0
                          ? Theme.of(context).textTheme.headline4!.copyWith(color: Colors.red)
                          : Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      (_model.homeTeam + _model.awayTeam) % 4 == 1 ? _gender(false) : 'B',
                      style: (_model.homeTeam + _model.awayTeam) % 4 == 1
                          ? Theme.of(context).textTheme.headline4!.copyWith(color: Colors.red)
                          : Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      (_model.homeTeam + _model.awayTeam) % 4 == 2 ? _gender(false) : 'B',
                      style: (_model.homeTeam + _model.awayTeam) % 4 == 2
                          ? Theme.of(context).textTheme.headline4!.copyWith(color: Colors.red)
                          : Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      (_model.homeTeam + _model.awayTeam) % 4 == 3 ? _gender(true) : 'A',
                      style: (_model.homeTeam + _model.awayTeam) % 4 == 3
                          ? Theme.of(context).textTheme.headline4!.copyWith(color: Colors.red)
                          : Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            TextButton(
              onPressed: () {
                if (!_started) {
                  startTimer();
                } else {
                  cancelTimer();
                }
              },
              child: Text(!_started ? 'Start game' : 'Pause game'),
            ),
          ],
        ),
      ),
    );
  }

  String _gender(bool isA) {
    if (isA)
      return _model.startWithMen ? 'Men' : 'Women';
    else
      return _model.startWithMen ? 'Women' : 'Men';
  }

  void _showConfigPopup() {
    showDialog(
      context: context,
      builder: (BuildContext parentContext) {
        MatchModel _popupModel = Provider.of(parentContext);
        _messagingController.text = _popupModel.gameTime.toString();

        return AlertDialog(
          title: Text(
            'Configure game',
          ),
          contentPadding: EdgeInsets.all(16),
          content: Column(
            children: [
              TextField(
                controller: _messagingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Game time in minutes',
                  labelStyle: Theme.of(context).textTheme.button,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                ),
              ),
              CheckboxListTile(
                value: _popupModel.startWithMen,
                title: Text('Men'),
                onChanged: (b) {
                  _popupModel.gameTime = int.parse(_messagingController.text);
                  _popupModel.startWithMen = b!;
                },
              ),
              CheckboxListTile(
                value: !_popupModel.startWithMen,
                title: Text('Women'),
                onChanged: (b) {
                  _popupModel.gameTime = int.parse(_messagingController.text);
                  _popupModel.startWithMen = !b!;
                },
              )
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).canvasColor,
              ),
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
            ),
            ElevatedButton(
              child: Text(
                'OK',
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _model.gameTime = int.parse(_messagingController.text);
                _model.gameMinutes = _model.gameTime;
                _model.gameSeconds = 0;

                _model.halftimeMinutes = (_model.gameTime / 2).floor();
                if (_model.halftimeMinutes * 2 == _model.gameTime - 1) {
                  _model.halftimeSeconds = 30;
                } else {
                  _model.halftimeSeconds = 0;
                }

                _model.startWithMen = _popupModel.startWithMen;

                navigatorKey.currentState!.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    if (!_started) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _tickDown();
        _tickDownHalftime();
      });
    }
    _started = true;
  }

  void _tickDown() {
    if (_model.gameSeconds == 0) {
      _model.gameSeconds = 59;
      if (_model.gameMinutes > 0) {
        _model.gameMinutes--;
      } else {
        // Stop timer + alarm!
        _timer.cancel();
        _started = false;
      }
    } else {
      _model.gameSeconds--;
    }
  }

  void _tickDownHalftime() {
    if (_model.halftimeSeconds == 0) {
      _model.halftimeSeconds = 59;
      if (_model.halftimeMinutes > 0) {
        _model.halftimeMinutes--;
      } else {
        _started = false;
      }
    } else {
      _model.halftimeSeconds--;
    }
  }

  void cancelTimer() {
    if (_started) {
      _timer.cancel();

      setState(() {
        _started = false;
      });
    }
  }
}
