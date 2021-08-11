import 'package:flutter/widgets.dart';

class MatchModel with ChangeNotifier {

  int _homeTeam = 0;
  int _awayTeam = 0;

  int get homeTeam => _homeTeam;
  int get awayTeam => _awayTeam;

  set homeTeam (int homeTeam) {
    _homeTeam = homeTeam;
    notifyListeners();
  }

  set awayTeam (int awayTeam) {
    _awayTeam = awayTeam;
    notifyListeners();
  }

  bool _startWithMen = false;

  bool get startWithMen => _startWithMen;

  set startWithMen (bool startWithMen) {
    _startWithMen = startWithMen;
    notifyListeners();
  }

  int _gameTime = 80;

  int get gameTime => _gameTime;

  set gameTime(int gameTime) {
   _gameTime = gameTime;
   notifyListeners();
  }

  String get score => _homeTeam.toString() + ' - ' + _awayTeam.toString();

  int _gameMinutes = 80;
  int _gameSeconds = 0;

  int get gameMinutes => _gameMinutes;

  set gameMinutes (int gameMinutes) {
    _gameMinutes = gameMinutes;

    notifyListeners();
  }

  int get gameSeconds => _gameSeconds;

  set gameSeconds (int gameSeconds) {
    _gameSeconds = gameSeconds;
    notifyListeners();
  }

  int _halftimeMinutes = 40;
  int _halftimeSeconds = 0;

  int get halftimeMinutes => _halftimeMinutes;
  int get halftimeSeconds => _halftimeSeconds;

  set halftimeMinutes (int halftimeMinutes) {
    _halftimeMinutes = halftimeMinutes;

    notifyListeners();
  }

  set halftimeSeconds (int halftimeSeconds) {
    _halftimeSeconds = halftimeSeconds;
    notifyListeners();
  }

  bool get isA {
    return (_homeTeam + _awayTeam) % 4 == 3 || (_homeTeam + _awayTeam) % 4 == 0;
  }

  bool get isB {
    return (_homeTeam + _awayTeam) % 4 == 1 || (_homeTeam + _awayTeam) % 4 == 2;
  }

}