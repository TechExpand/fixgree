import 'package:flutter/material.dart';

class ArtisanProvider extends ChangeNotifier {
  int _catalogueCount = 0;
  int _commentsCount = 0;

  int get getCatalogueCount => _catalogueCount;
  set setCatalogueCount(int value) {
    _catalogueCount = value;
    notifyListeners();
  }

  int get getCommentsCount => _commentsCount;
  set setCommentsCount(int value) {
    _commentsCount = value;
    notifyListeners();
  }
}
