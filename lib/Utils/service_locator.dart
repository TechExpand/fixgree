import 'package:fixme/Services/network_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<WebServices>(WebServices());
}