
import 'package:flutter/foundation.dart';

Map<String, String> data = {'': ''};
List<Map<String, String>> popularServices = [
  {'text': 'Food Vendor', 'image': 'assets/images/pp1.jpg', 'id': '122'},
  {'text': 'Dispatch Rider', 'image': 'assets/images/p6.jpg', 'id': '155'},
  {'text': 'Web Designer', 'image': 'assets/images/pp2.jpg', 'id': '68'},
  {'text': 'Graphic', 'image': 'assets/images/pp3.jpg', 'id': '169'},
  {'text': 'Electrician', 'image': 'assets/images/pp4.png', 'id': '1'},
  {'text': 'Plumber', 'image': 'assets/images/p2.png', 'id': '165'},
  {'text': 'Mechanic', 'image': 'assets/images/pp5.jpg', 'id': '2'},
];

List<Map<String, String>> featuredServices = [
  {
    'image': 'assets/images/p1.png',
    'text': 'Design an Interface for your website.',
    'price': '10,000'
  },
  {
    'image': 'assets/images/p2.png',
    'text': 'Quick solution to your plumbing problems.',
    'price': '5000'
  },
  {
    'image': 'assets/images/p3.png',
    'text': 'Fix your electrical issues effeciently.',
    'price': '9000'
  },
  {
    'image': 'assets/images/p1.png',
    'text': 'Fix your mechanical issues effeciently.',
    'price': '3000'
  },
];









class StateInfo{
  String name;
  int id;
  StateInfo(this.name, this.id);
}

List<StateInfo> datas = [
  StateInfo('Abia', 1),
  StateInfo('Adamawa', 2),
  StateInfo('Akwa Ibom', 3),
  StateInfo('Anambra', 4),
  StateInfo('Bauchi', 5),
  StateInfo('Bayelsa', 6),
  StateInfo('Benue', 7),
  StateInfo('Borno', 8),
  StateInfo('Cross River', 9),
  StateInfo('Delta', 10),
  StateInfo('Ebonyi', 11),
  StateInfo('Edo',12),
  StateInfo('Ekiti', 13),
  StateInfo('Enugu', 14),
  StateInfo('Gombe', 15),
  StateInfo('Imo', 16),
  StateInfo('Jigawa', 17),
  StateInfo('Kaduna', 18),
  StateInfo('Kano', 19),
  StateInfo('Katsina', 20),
  StateInfo('Kebbi', 21),
  StateInfo('Kogi', 22),
  StateInfo('Kwara', 23),
  StateInfo('Lagos', 24),
  StateInfo('Nasarawa', 25),
  StateInfo('Niger', 26),
  StateInfo('Ogun', 27),
  StateInfo('Ondo', 28),
  StateInfo('Osun', 29),
  StateInfo('Oyo', 30),
  StateInfo('Plateau', 31),
  StateInfo('Rivers', 32),
  StateInfo('Sokoto', 33),
  StateInfo('Taraba', 34),
  StateInfo('Yobe', 35),
  StateInfo('Zamfara', 36),
  StateInfo('Abuja', 37),

];

class LgaProvider with ChangeNotifier {
  List<StateInfo> allLgaList = datas;

  StateInfo seletedinfo;

  changeSelectedLGA(value){
    seletedinfo = value;
    print(seletedinfo.name);
    print(seletedinfo.name);
    notifyListeners();
  }


  // changeLGA(StateInfo services) {
  //   seletedinfo = services;
  //   print(seletedinfo.name);
  //   notifyListeners();
  // }


}


