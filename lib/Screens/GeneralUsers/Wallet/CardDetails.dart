import 'dart:io';

import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';

class CardDetails extends StatefulWidget {
  @override
  _WalletAddCardState createState() => _WalletAddCardState();
}

class _WalletAddCardState extends State<CardDetails> {
  TextEditingController cardNo = new TextEditingController();
  TextEditingController expiryDate = new TextEditingController();
  TextEditingController cvvCode = new TextEditingController();
  var publicKey = 'pk_live_624bc595811d2051eead2a9baae6fe3f77f7746f';

  @override
  void initState(){
    super.initState();
    PaystackPlugin.initialize(publicKey: publicKey);
  }

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
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );
      if (response.status) {
        network.validatePayment(response.reference);
        print(response.reference);
      }
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Card Details',
            style: TextStyle(
                color: Color(0xFF9B049B),
                fontSize: 21,
                fontFamily: 'Firesans',
                height: 1.4,
                fontWeight: FontWeight.w500)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
        ),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: network.getCardDetails() ,
          builder: (context, snapshot) {
            return snapshot.hasData?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cards', style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontFamily: 'Firesans',
                      height: 1.4,
                      fontWeight: FontWeight.w500)),
                ),
                Card(
                  child: ListTile(
                    trailing:  Text("${snapshot.data['exp_month']+'/'+snapshot.data['exp_year']}",style: TextStyle(
            color: Colors.black,
            fontFamily: 'Firesans',
            )),
                    subtitle:  Text("******${snapshot.data['last4']}",style: TextStyle(
            color: Colors.black,
            fontFamily: 'Firesans',
            )),
                    title:  Text(snapshot.data['bank'],style: TextStyle(
            color: Colors.black,
            fontFamily: 'Firesans',
 )),
                    leading: Text(snapshot.data['card_type'],style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Firesans',
                        fontWeight: FontWeight.bold)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 150,
                    height: 40,
                    margin:
                    const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF9B049B)) ,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.transparent,
                    ),
                    child: new FlatButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () async {
                        paymentMethod(context, 5000, network.email);

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Link New Card',
                              style: TextStyle(
                                  color: Color(0xFF9B049B),
                                  fontFamily: 'Firesans',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ):Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Theme(
                    data: Theme.of(context).copyWith(
                        accentColor: Color(0xFF9B049B)),
                    child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                Text('Loading',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ],
            ),);
          }
      ),
    );
  }
}
