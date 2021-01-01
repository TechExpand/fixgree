import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Model/UserBankInfo.dart';
import 'package:fixme/Utils/utils.dart';

class WalletFund extends StatefulWidget {
  final UserBankInfo userBankInfo;

  WalletFund({@required this.userBankInfo});

  @override
  _WalletFundState createState() => _WalletFundState();
}

class _WalletFundState extends State<WalletFund> {
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
              Text('Fund Wallet?',
                  style: TextStyle(
                      fontFamily: 'Firesans',
                      fontSize: 18,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600))
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Color(0xFFEBCDEB),
              border: Border.all(color: Color(0xFF9B049B)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFF1F1FD),
                    blurRadius: 15.0,
                    offset: Offset(0.3, 4.0))
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('Transaction fee is FREE',
                      style: TextStyle(
                          fontFamily: 'Firesans',
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text('BANK TRANSFER',
                      style: TextStyle(
                          fontFamily: 'Firesans',
                          fontSize: 24,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600)),
                ),
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
                      Text('Account Information',
                          style: TextStyle(
                              fontFamily: 'Firesans',
                              fontSize: 17,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                  height: 115,
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
                            child: Text('${widget.userBankInfo.accountName}'.toUpperCase(),
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 21,
                                    fontFamily: 'Firesans',
                                    height: 1.4,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('${widget.userBankInfo.bankName}',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 18,
                                    fontFamily: 'Firesans',
                                    height: 1,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.userBankInfo.accountNumber,
                              style: TextStyle(
                                // letterSpacing: 4,
                                  color: Color(0xFF333333),
                                  fontSize: 20,
                                  fontFamily: 'Firesans',
                                  fontWeight: FontWeight.w600)),
                          IconButton(
                            icon: Icon(Icons.content_copy),
                            color: Color(0xFF333333),
                            onPressed: (){

                            },
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Wrap(
              children: [
                Text(
                    'Sending money to that account enters your Fixme wallet immediately.',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF9B049B),
                        fontSize: 18,
                        fontFamily: 'Firesans',
                        height: 1.4,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
