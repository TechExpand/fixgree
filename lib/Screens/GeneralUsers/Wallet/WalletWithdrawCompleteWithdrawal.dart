import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Services/network_service.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:provider/provider.dart';
import 'package:fixme/Model/BankInfo.dart';

import 'Providers/BankProvider.dart';
import 'SecurePin.dart';

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
  BorderRadiusGeometry radiusTop = BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
  );

  BorderRadiusGeometry radiusBottom = BorderRadius.only(
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var network = Provider.of<WebServices>(context);
    return ChangeNotifierProvider<BankProvider2>(
      create: (context) => BankProvider2(),
      child: Scaffold(
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
                Text('Wallet Withdrawal',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w600))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, right: 25, left: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFD0D0D0)),
              ),
              child: Column(
                children: [
                  Container(
                    // margin: const EdgeInsets.only(top: 10, right: 25, left: 25),
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
                        Text('Beneficiary account',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF333333),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    // margin: const EdgeInsets.only(right: 25, left: 25),
                    height: 165,
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 7, left: 12, right: 8, bottom: 10),
                          child: Wrap(
                            children: [
                              Text('${widget.accountName}',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 21,
                                    height: 1.4,
                                  )),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Account No: ',
                                style: TextStyle(
                                  // letterSpacing: 4,
                                  color: Color(0xFF333333),
                                  fontSize: 20,
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${widget.accountNumber}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      color: Color(0xFF333333),
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('${widget.bankInfo.name}',
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
              margin: const EdgeInsets.only(top: 20, right: 25, left: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFD0D0D0)),
              ),
              child: Column(
                children: [
                  Container(
                    // margin: const EdgeInsets.only(top: 20, right: 25, left: 25),
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
                        Text('Amount',
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                  ),
                  Container(
                    // margin: const EdgeInsets.only(right: 25, left: 25),
                    height: 230,
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
                    child: Consumer<BankProvider2>(
                        builder: (context, model, widget) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 12),
                            margin: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 9),
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: model.getAmountStatus
                                    ? Border.all(color: Colors.red)
                                    : Border.all(color: Color(0xFFF1F1FD)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFFF1F1FD).withOpacity(0.5),
                                      blurRadius: 10.0,
                                      offset: Offset(0.3, 4.0))
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    '\₦',
                                    style: TextStyle(
                                        color: Color(0xFF555555), fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      model.setAmount = val;
                                    },
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF270F33),
                                        fontWeight: FontWeight.w600),
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
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text('Narration',
                                    style: TextStyle(
                                        color: Color(0xFF4B4B4B),
                                        fontSize: 18,
                                        height: 1.4,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 17),
                            margin: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: model.getNarrationStatus
                                    ? Border.all(color: Colors.red)
                                    : Border.all(color: Color(0xFFF1F1FD)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFFF1F1FD).withOpacity(0.5),
                                      blurRadius: 10.0,
                                      offset: Offset(0.3, 4.0))
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (val) {
                                      model.setNarration = val;
                                    },
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF270F33),
                                        fontWeight: FontWeight.w600),
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text('Save as beneficiary',
                                      style: TextStyle(
                                          color: Color(0xFF4B4B4B),
                                          fontSize: 18,
                                          height: 1.4,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: CupertinoSwitch(
                                      value: model.getSaveBeneficiary,
                                      trackColor: Color(0xFFF1F1F1),
                                      activeColor: Color(0xFF9B049B),
                                      onChanged: (value) {
                                        model.setSaveBeneficiary = value;
                                      }),
                                )
                              ])
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
            Consumer<BankProvider2>(builder: (context, model, _) {
              return model.getIsValidated
                  ? Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Color(0xFF9B049B),
                      ),
                      child: new FlatButton(
                        padding: EdgeInsets.all(10),
                        onPressed: () async {
                          if (model.getAmount.isEmpty) {
                            model.setAmountStatus = true;
                          } else if (model.getNarration.isEmpty) {
                            model.setNarrationStatus = true;
                          } else {
                            model.setIsValidated = false;
                            String hasPin = await network.checkSecurePin();
                            if (hasPin == 'false') {
                              model.setIsValidated = true;
                              displayCreateSecurePinBottomModal(
                                  context: context,
                                  bankInfo: widget.bankInfo,
                                  accountName: widget.accountName,
                                  accountNumber: widget.accountNumber,
                                  amount: model.getAmount,
                                  isBeneficiary: model.getSaveBeneficiary,
                                  narration: model.getNarration);
                            } else if (hasPin == 'true') {
                              model.setIsValidated = true;
                              displayEnterSecurePinBottomModal(
                                  context: context,
                                  bankInfo: widget.bankInfo,
                                  accountName: widget.accountName,
                                  accountNumber: widget.accountNumber,
                                  amount: model.getAmount,
                                  isBeneficiary: model.getSaveBeneficiary,
                                  narration: model.getNarration);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Complete withdrawal',
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
                  : Container(
                      margin: const EdgeInsets.only(top: 25, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(accentColor: Color(0xFF9B049B)),
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
      ),
    );
  }
}
