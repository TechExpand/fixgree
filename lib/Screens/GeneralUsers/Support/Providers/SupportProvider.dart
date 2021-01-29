import 'package:flutter/foundation.dart';

class SupportProvider extends ChangeNotifier {
  String _selectedFeedback;
  String get getSelectedFeedback => _selectedFeedback;
  set setSelectedFeedback(String newValue) {
    _selectedFeedback = newValue;
    notifyListeners();
    if (newValue == 'Other Feedback') {
      _isFieldEnabled = true;
      if (_otherFeedback.isNotEmpty) {
        _isButtonEnabled = true;
      }
      _isButtonEnabled = false;
    } else {
      _isFieldEnabled = false;
      _isButtonEnabled = true;
    }
  }

  bool _isFieldEnabled = false;
  bool get getIsFieldEnabled => _isFieldEnabled;

  bool _isButtonEnabled = false;
  bool get getIsButtonEnabled => _isButtonEnabled;

  String _otherFeedback = '';
  String get getOtherFeedback => _otherFeedback;
  set setOtherFeedback(String newValue) {
    _otherFeedback = newValue;
    notifyListeners();
    if (newValue.isEmpty) {
      _isButtonEnabled = false;
      notifyListeners();
    } else {
      _isButtonEnabled = true;
      notifyListeners();
    }
  }
}
