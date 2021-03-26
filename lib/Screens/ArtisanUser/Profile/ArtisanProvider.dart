import 'package:flutter/material.dart';

class ArtisanProvider extends ChangeNotifier {
  int _catalogueCount = 0;
  int _productCount = 0;
  int _commentsCount = 0;
  bool _isExpanded = false;

  int get getCatalogueCount => _catalogueCount;
  set setCatalogueCount(int value) {
    _catalogueCount = value;
    notifyListeners();
  }

  int get getProductCount => _productCount;
  set setProductCount(int value) {
    _productCount = value;
    notifyListeners();
  }

  int get getCommentsCount => _commentsCount;
  set setCommentsCount(int value) {
    _commentsCount = value;
    notifyListeners();
  }

  bool get getExpandedStatus => _isExpanded;
  set setExpandedStatus(bool newValue) {
    _isExpanded = newValue;
    notifyListeners();
  }
}
