import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Model/BankInfo.dart';
import 'package:fixme/Utils/utils.dart';

class WalletWithdrawCompleteWithdrawal extends StatefulWidget {
  final BankInfo bankInfo;
  final String accountNumber;
  final String accountName;

  WalletWithdrawCompleteWithdrawal(
      {@required this.bankInfo,
      @required this.accountNumber,
      @required this.accountName});

  @override
  _WalletWithdrawCompleteWithdrawalState createState() =>
      _WalletWithdrawCompleteWithdrawalState();
}

class _WalletWithdrawCompleteWithdrawalState
    extends State<WalletWithdrawCompleteWithdrawal> {
  TextEditingController amount = new TextEditingController();

  BorderRadiusGeometry radiusTop = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  BorderRadiusGeometry radiusBottom = BorderRadius.only(
    bottomLeft: Radius.circular(24.0),
    bottomRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
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
                width: 12.0,
                height: 40.0,
                color: Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: 1.5,
                  width: 19,
                  color: Color(0xFFD1D1D3),
                ),
              ),
              Text('Wallet Transfer',
                  style: TextStyle(
                      fontFamily: 'Firesans',
                      fontSize: 18,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600))
            ],
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 1.5,
                          width: 19,
                          color: Color(0xFFD1D1D3),
                        ),
                      ),
                      Text('Beneficiary account',
                          style: TextStyle(
                              fontFamily: 'Firesans',
                              fontSize: 17,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  height: 135,
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
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('Leonardo De Ser',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 21,
                                    fontFamily: 'Firesans',
                                    height: 1.4,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Account No: ',
                              style: TextStyle(
                                  // letterSpacing: 4,
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontFamily: 'Firesans',
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('48459845',
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Color(0xFF333333),
                                    fontSize: 20,
                                    fontFamily: 'Firesans',
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Access Bank',
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 21,
                                  fontFamily: 'Firesans',
                                  height: 1,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
                  height: 55,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 1.5,
                          width: 19,
                          color: Color(0xFFD1D1D3),
                        ),
                      ),
                      Text('Amount',
                          style: TextStyle(
                              fontFamily: 'Firesans',
                              fontSize: 17,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  height: 100,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 55,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFFF1F1FD).withOpacity(0.5),
                                  blurRadius: 10.0,
                                  offset: Offset(0.3, 4.0))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                FeatherIcons.dollarSign,
                                color: Color(0xFF555555),
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontFamily: 'Firesans',
                                    fontSize: 16,
                                    color: Color(0xFF270F33),
                                    fontWeight: FontWeight.w600),
                                controller: amount,
                                decoration: InputDecoration.collapsed(
                                  hintText: '',
                                  focusColor: Color(0xFF2B1137),
                                  fillColor: Color(0xFF2B1137),
                                  hoverColor: Color(0xFF2B1137),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 50,
            margin:
                const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Color(0xFF9B049B),
            ),
            child: new FlatButton(
              padding: EdgeInsets.all(10),
              onPressed: () async {},
              child: Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Complete withdrawal',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Firesans',
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      FeatherIcons.checkCircle,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
