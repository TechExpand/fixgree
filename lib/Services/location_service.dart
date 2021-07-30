import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService with ChangeNotifier {
  double locationLatitude = 0;
  double locationLongitude = 0;

  Future getCurrentLocation() async {
    try {
      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      locationLatitude = position.latitude;
      locationLongitude = position.longitude;
      notifyListeners();
      return position;
    } catch (e) {
      print(e);
    }
  }
}
