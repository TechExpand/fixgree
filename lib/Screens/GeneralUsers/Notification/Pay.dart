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
  var controller;
  var data;
//
  Pay({@required this.controller, @required this.data});
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
              Row(
                children: [
                  Container(
                    width: 25.0,
                    height: 40.0,
                    color: Colors.transparent,
                  ),
                  Text('Pay To Fixme',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600))
                ],
              ),
              Consumer<BankProvider>(builder: (context, model, widget) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                      height: 140,
                      padding: const EdgeInsets.only(left: 15),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: transferModes.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              model.setSelectValue = index;
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              height: 140,
                              width: 120,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: model.getSelectValue == index
                                      ? Color(0xFFEBCDEB)
                                      : Colors.white,
                                  border: Border.all(color: Color(0xFF9B049B)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                  child: Text(transferModes[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500))),
                            ),
                          );
                        },
                      )),
                );
              }),












              Consumer<BankProvider>(builder: (context, model, widget) {
                return model.getSelectValue == 1
                    ?               Container(child: Text(''),)


                    : model.getIsValidated
                    ?  Container(
                margin: const EdgeInsets.only(top: 20, right: 25, left: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFD0D0D0)),
                ),
                child: Column(
                  children: [
                    Container(
                      // margin:
                      //     const EdgeInsets.only(top: 20, right: 25, left: 25),
                      height: 55,
                      alignment: Alignment.centerLeft,
                      width: deviceSize.width,
                      decoration: BoxDecoration(
                        borderRadius: radiusTop,
                        color: Color(0xFFE6E7E8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: 40.0,
                            color: Colors.transparent,
                          ),
                          Text('Transfer to',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                              ))
                        ],
                      ),
                    ),


                    Container(
                      // margin: const EdgeInsets.only(right: 25, left: 25),
                      height: 145,
                      decoration: BoxDecoration(
                        borderRadius: radiusBottom,
                        color: Color(0xFFFFFFFF),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFF1F1FD),
                              blurRadius: 15.0,
                              offset: Offset(0.3, 4.0))
                        ],
                      ),
                      child: FutureBuilder(
                        future: network.getUserBankInfo(data.bidderId) ,
                        builder: (context, snapshot) {
                          return snapshot.data==null?Center(child: Text('Loading',  style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 22,
                              height: 1.4))):Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 7, bottom: 5),
                                    child: Text(
                                    snapshot.data==null?'':snapshot.data['bankName'].toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 22,
                                            height: 1.4)),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Account No: ',
                                        style: TextStyle(
                                          // letterSpacing: 4,
                                            color: Color(0xFF333333),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400)),
                                    Text(
                                        snapshot.data==null?'':snapshot.data['accountNumber'].toString(),
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 21,
                                            fontWeight: FontWeight.w400)),
                                    IconButton(
                                      icon: Icon(Icons.content_copy),
                                      color: Color(0xFF333333),
                                      onPressed: () async {
                                        FlutterClipboard.copy(
                                            snapshot.data==null?'':snapshot.data['accountNumber'].toString())
                                            .then((value) {
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                              content: Text('Account number copied.')));
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Account Name: ',
                                        style: TextStyle(
                                          // letterSpacing: 4,
                                            color: Color(0xFF333333),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400)),
                                    Text(
                                        snapshot.data==null?'':snapshot.data['account_name'].toString(),
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 21,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    )
                  ],
                ),
              )


                    : Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              accentColor: Color(0xFF9B049B)),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),







              Consumer<BankProvider>(builder: (context, model, widget) {
                var data = Provider.of<DataProvider>(context);
                return model.getSelectValue == 1
                    ? Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                        top: 25, left: 20, right: 20, bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(0xFF9B049B),
                  ),
                  child: new FlatButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        Navigator.pop(context);
                        controller.jumpToPage(1);
                        data.setSelectedBottomNavBar(1);

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pay with wallet',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                  ),
                    )
                    : model.getIsValidated
                    ? Container(child: Text(''),)
                    : Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              accentColor: Color(0xFF9B049B)),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),






            ],
          ),
        );
      },
    );
  }
}
