import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Model/UserBankInfo.dart';

class WalletFund extends StatefulWidget {
  final UserBankInfo userBankInfo;

  WalletFund({@required this.userBankInfo});

  @override
  _WalletFundState createState() => _WalletFundState();
}

class _WalletFundState extends State<WalletFund> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  BorderRadiusGeometry radiusTop = BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
  );

  BorderRadiusGeometry radiusBottom = BorderRadius.only(
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  );

  @override
  Widget build(BuildContext context) {
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
              Text('Fund Wallet with?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 25, left: 25),
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
                  padding: const EdgeInsets.only(top: 25, bottom: 10, left: 15),
                  child: Row(
                    children: [
                      Text('Transaction fee is FREE',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15),
                  child: Row(
                    children: [
                      Text('Bank Transfer',
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFD0D0D0)),
            ),
            child: Column(
              children: [
                Container(
                  // margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
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
                      Text('Account Information',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF333333),
                          ))
                    ],
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.only(bottom: 15),
                  height: 125,
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
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                                '${widget.userBankInfo.accountName}'
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 24,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('${widget.userBankInfo.bankName}',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 20,
                                  height: 1,
                                )),
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
                                  fontWeight: FontWeight.w600)),
                          IconButton(
                            icon: Icon(Icons.content_copy),
                            color: Color(0xFF333333),
                            onPressed: () async {
                              FlutterClipboard.copy(
                                      '${widget.userBankInfo.accountNumber}')
                                  .then((value) {
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Account number copied.')));
                              });
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
                        height: 1.4,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
