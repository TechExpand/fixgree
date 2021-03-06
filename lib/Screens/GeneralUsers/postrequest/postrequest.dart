import 'dart:io';

import 'package:fixme/Screens/GeneralUsers/Wallet/CardPayment.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Model/service.dart';
import 'package:fixme/Screens/GeneralUsers/postrequest/describe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  var publicKey = 'pk_live_624bc595811d2051eead2a9baae6fe3f77f7746f';
  List categorylist = ['Category1', 'Category2', 'Category3'];
  String thevalue;
  var selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final plugin = PaystackPlugin();

  @override
  void initState(){
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  List<Services> result = [];

  @override
  Widget build(BuildContext context) {
    String _getReference() {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }
      return 'ChargedFrom${platform}_${DateTime
          .now()
          .millisecondsSinceEpoch}';
    }
    var network = Provider.of<WebServices>(context, listen: false);

    paymentMethod(context, amount, email)async{
      Charge charge = Charge()
        ..amount = amount
//        ..putMetaData('is_refund', is_refund)
//        ..putMetaData('artisan_id', signController.currentUser.user.id)
//        ..putMetaData('start_date', DateTime.now().toString())
        ..reference = _getReference()
      // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = email;
      CheckoutResponse response = await plugin.checkout(
        context,
        logo: Image.asset(
          'assets/images/fixme.png',
          scale: 5,
        ),
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );
      if (response.status) {

        network.validatePayment(response.reference);
        Utils().storeData('paymentToken', 'active');
        print(response.reference);
      }
    }


    PostRequestProvider postRequestProvider =
    Provider.of<PostRequestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
        title: Text('Post A Request',
            style: GoogleFonts.poppins(
                color: Color(0xFF333333), fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            postRequestProvider.gotit
                ? Card(
              color: Color(0xFF9B049B),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 5, right: 5),
                  child: Column(
                    children: [
                      Text(
                        'How Does Your Request Work?',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.star,
                                color: Colors.white, size: 13),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  'We send your request to all artisan within your location.',
                                  style: TextStyle(color: Colors.white)),
                            )
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.star,
                                color: Colors.white, size: 13),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  'Artisan will then send you their offers and you can choose who you would want to work with.',
                                  style: TextStyle(color: Colors.white)),
                            )
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.star,
                                color: Colors.white, size: 13),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  'Once you have decided, you can contact them.',
                                  style: TextStyle(color: Colors.white)),
                            )
                          ]),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          postRequestProvider.changeGotit();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text('Got it'.toUpperCase(),
                                  style: TextStyle(color: Colors.white))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0, bottom: 13),
              child: Text('What do you want to get done?'),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: ()async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var status = prefs.getString('paymentToken');
                if(status == null || status == 'null' || status == '' || status == 'in_active'){
                  paymentMethod(context, 5000, network.email);
                }
                else{
                  result = postRequestProvider.allservicesList;
                  dialogPage(context);
                }
                },
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                enabled: false,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black38),
                  labelText: postRequestProvider.selecteService == null
                      ? 'Select Service'
                      : postRequestProvider.selecteService.service,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 3, color: Colors.black38),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(26)),
                child: FlatButton(
                  disabledColor: Color(0x909B049B),
                  onPressed: postRequestProvider.selecteService == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) {
                          return DescribePage(); //SignUpAddress();
                        },
                        transitionsBuilder: (context, animation,
                            secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  color: Color(0xFF9B049B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(26)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.1,
                          minHeight: 45.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dialogPage(ctx) {
    PostRequestProvider postRequestProvider =
    Provider.of<PostRequestProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return AlertDialog(
                title: TextFormField(
                  onChanged: (value) {
                    setStates(() {
                      searchServices(value);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Search Services',
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 500,
                          child: ListView.builder(
                            itemCount: result == null ? 0 : result.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  postRequestProvider
                                      .changeSelectedService(result[index]);
                                },
                                child: ListTile(
                                  title: Text('${result[index].service}'),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((v) {
      setState(() {});
    });
  }

  void searchServices(userInputValue) {
    PostRequestProvider postRequestProvider =
    Provider.of<PostRequestProvider>(context, listen: false);
    result = postRequestProvider.allservicesList
        .where((service) => service.service
        .toLowerCase()
        .contains(userInputValue.toLowerCase()))
        .toList();
  }
}
