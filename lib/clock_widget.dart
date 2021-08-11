import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'model/match_model.dart';

class ClockWidget extends StatefulWidget {
  final bool large;
  final bool halfTimeClock;

  ClockWidget({
    this.large = true,
    this.halfTimeClock = false,
  });

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late int _minutes;
  late int _seconds;

  late MatchModel _model;

  @override
  Widget build(BuildContext context) {
    _model = Provider.of(context);
    _initClock();

    return Text(
      _paddedNumber(_minutes) + ':' + _paddedNumber(_seconds),
      style: widget.large ? Theme.of(context).textTheme.headline1 : Theme.of(context).textTheme.headline3,
    );
  }

  String _paddedNumber(int number) {
    if (number < 10) {
      return '0$number';
    } else {
      return '$number';
    }
  }

  void _initClock() {
    if (widget.halfTimeClock) {
      _minutes = _model.halftimeMinutes;
      _seconds = _model.halftimeSeconds;
    } else {
      _minutes = _model.gameMinutes;
      _seconds = _model.gameSeconds;
    }
  }
}
