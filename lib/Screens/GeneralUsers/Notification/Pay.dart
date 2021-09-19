import 'package:clipboard/clipboard.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Screens/GeneralUsers/Wallet/Providers/BankProvider.dart';
import 'package:fixme/Screens/GeneralUsers/Wallet/WalletPayCompletePayment.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Model/UserBankInfo.dart';
import 'package:fixme/Screens/GeneralUsers/Wallet/CardPayment.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Screens/GeneralUsers/Wallet/SeeBeneficiaries.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Model/BankInfo.dart';
import 'package:provider/provider.dart';


class Pay extends StatelessWidget{
 // var controller;
  var data;
//
  Pay({@required this.data});
  var transferModes = ['Direct \n Transfer', 'Wallet \n Transfer'];

  TextEditingController accountNo = new TextEditingController();

  BorderRadiusGeometry radiusTop = BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
  );

  BorderRadiusGeometry radiusBottom = BorderRadius.only(
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  );
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    var network = Provider.of<WebServices>(context, listen: false);
    return ChangeNotifierProvider<BankProvider>(
      create: (_) => BankProvider(),
      builder: (context, _) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
            ),
            elevation: 0,
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: 140,
                margin: const EdgeInsets.only(top: 20, right: 5),
                alignment: Alignment.center,
                child: Image.asset('assets/images/fixme.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                   Text('Paid To Fixme',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Firesans',
                              height: 1.4,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600),textAlign: TextAlign.center ),

                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Center(
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Bidded amount would be debited from your card, but would only be'
                      ' released to the business on confirmation that the service/goods has been delivered, else cash would be reinstated back to you.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600), textAlign: TextAlign.center ,),
                ),
              )

            ],
          ),
        );
      },
    );
  }
}
