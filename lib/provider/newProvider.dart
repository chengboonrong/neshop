import 'package:flutter/material.dart';
import 'package:neshop/utils/game.dart';

class NewGameListProvider extends ChangeNotifier {
  final List<Game> _newGameList = [];

  List<Game> get getNewGameList => _newGameList;

  int get getLength => _newGameList.length;

  void addNewGames(List<Game> games) {
    _newGameList.addAll(games);
    notifyListeners();
  }
}
