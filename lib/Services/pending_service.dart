
import 'package:flutter/material.dart';

class PendingProvider with ChangeNotifier {

  bool _loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String baseUrl = 'https://manager.fixme.ng/new-project';

  bool get loading => _loading;
  bool login = false;

  isLoading(loading) {
    _loading = loading;
    notifyListeners();
  }

}
