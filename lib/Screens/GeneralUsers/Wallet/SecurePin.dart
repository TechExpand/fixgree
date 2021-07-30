import 'package:flutter/material.dart';
import 'package:fixme/Services/network_service.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Model/BankInfo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'Providers/PinProvider.dart';
import 'TransactionFailed.dart';
import 'TransactionSuccessful.dart';

BorderRadiusGeometry radiusTop = BorderRadius.only(
  topLeft: Radius.circular(15.0),
  topRight: Radius.circular(15.0),
);

displayCreateSecurePinBottomModal(
    {BuildContext context,
    BankInfo bankInfo,
    String accountNumber,
    String accountName,
    String amount,
    String narration,
    bool isBeneficiary}) {
  var deviceSize = MediaQuery.of(context).size;
  var viewInsets = MediaQuery.of(context).viewInsets;
  var network = Provider.of<WebServices>(context, listen: false);

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    // enableDrag: true,
    builder: (context) {
      return ChangeNotifierProvider<PinProvider>(
          create: (context) => PinProvider(),
          child: SingleChildScrollView(
              child: Consumer<PinProvider>(builder: (context, model, widget) {
            return Container(
              height: deviceSize.height / 2,
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0), borderRadius: radiusTop),
              padding: EdgeInsets.only(bottom: viewInsets.bottom, top: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      Text('Set a secure pin',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Wrap(
                      children: [
                        Text(
                            'Set a pin that will be used to process all your transactions.',
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF555555),
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 12),
                    margin: const EdgeInsets.only(
                        bottom: 15, left: 12, right: 12, top: 15),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: model.getPinStatus
                            ? Border.all(color: Colors.red)
                            : null,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFF1F1FD),
                              blurRadius: 15.0,
                              offset: Offset(0.3, 4.0))
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            FeatherIcons.lock,
                            color: Color(0xFF555555),
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [CreditCardCvcInputFormatter()],
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              model.setPin = val;
                            },
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF270F33),
                                fontWeight: FontWeight.w600),
                            // controller: securePin,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Enter secure pin',
                              hintStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              focusColor: Color(0xFF2B1137),
                              fillColor: Color(0xFF2B1137),
                              hoverColor: Color(0xFF2B1137),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(
                        top: 10, left: 12, right: 12, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(0xFF9B049B),
                    ),
                    child: new FlatButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () async {
                        if (model.getPin.isEmpty) {
                          model.setPinStatus = true;
                        } else {
                          model.setIsValidated = false;
                          String pin = model.getPin;
                          model.setIsValidated =
                              await network.setSecurePin(secPin: pin) == 'true'
                                  ? true
                                  : false;
                          if (model.getIsValidated) {
                            Future.delayed(Duration(milliseconds: 100), () {
                              Navigator.of(context).pop();
                              displayEnterSecurePinBottomModal(
                                  context: context,
                                  bankInfo: bankInfo,
                                  accountName: accountName,
                                  accountNumber: accountNumber,
                                  amount: amount,
                                  isBeneficiary: true,
                                  narration: narration);
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add Pin',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                                height: 25,
                                width: 25,
                                child: model.getIsValidated
                                    ? Icon(
                                        FeatherIcons.arrowRightCircle,
                                        color: Colors.white,
                                      )
                                    : Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            accentColor: Color(
                                                                0xFF9B049B)),
                                                    child:
                                                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                       strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                                    )),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          })));
    },
  );
}

displayEnterSecurePinBottomModal(
    {BuildContext context,
    BankInfo bankInfo,
    String accountNumber,
    String accountName,
    String amount,
    String narration,
    bool isBeneficiary = false}) {
  var deviceSize = MediaQuery.of(context).size;
  var viewInsets = MediaQuery.of(context).viewInsets;
  var network = Provider.of<WebServices>(context, listen: false);

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ChangeNotifierProvider<PinProvider>(
          create: (context) => PinProvider(),
          child: SingleChildScrollView(
            child: Consumer<PinProvider>(builder: (context, model, widget) {
              return Container(
                height: deviceSize.height / 2,
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF), borderRadius: radiusTop),
                padding: EdgeInsets.only(bottom: viewInsets.bottom, top: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 15.0,
                          height: 45.0,
                          color: Colors.transparent,
                        ),
                        Text('Enter secure pin',
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Row(
                        children: [
                          Text('Enter your personal security pin',
                              softWrap: true,
                              style: TextStyle(
                                color: Color(0xFF555555),
                                fontSize: 18,
                                height: 1.4,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 55,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 12, right: 12, top: 15),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: model.getPinStatus
                              ? Border.all(color: Colors.red)
                              : Border.all(color: Color(0xFFF1F1FD)),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFFF1F1FD),
                                blurRadius: 15.0,
                                offset: Offset(0.3, 4.0))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              FeatherIcons.lock,
                              color: Color(0xFF555555),
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [CreditCardCvcInputFormatter()],
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                model.setPin = val;
                              },
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF270F33),
                                  fontWeight: FontWeight.w600),
                              // controller: securePin,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter secure pin',
                                hintStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                focusColor: Color(0xFF2B1137),
                                fillColor: Color(0xFF2B1137),
                                hoverColor: Color(0xFF2B1137),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    model.getTransactionStatus
                        ? Container(
                            height: 50,
                            margin: const EdgeInsets.only(
                                top: 10, left: 12, right: 12, bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: Color(0xFF9B049B),
                            ),
                            child: new FlatButton(
                              padding: EdgeInsets.all(10),
                              onPressed: () async {
                                if (model.getPin.isEmpty) {
                                  model.setPinStatus = true;
                                } else {
                                  model.setTransactionStatus = false;
                                  Map<String, String> result =
                                      await network.initiateTransfer(
                                          accountName: accountName,
                                          accountNumber: accountNumber,
                                          amount: amount,
                                          bankCode: bankInfo.code,
                                          isBeneficiary: isBeneficiary,
                                          naration: narration,
                                          secPin: model.getPin);
                                  model.setTransactionStatus =
                                      result['reqRes'] == 'true' ?? false;
                                  print('The status: ' +
                                      model.getTransactionStatus.toString());
                                  Navigator.of(context).pop();
                                  if (model.getTransactionStatus) {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return TransactionSuccessful();
                                        },
                                        //9944011918
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return TransactionFailed(
                                            message: result['message'],
                                          );
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
                                  }
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 7, right: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Pay',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    //           Container(
                                    //               height: 25,
                                    //               width: 25,
                                    //               child: model.getTransactionStatus
                                    //                   ? Icon(
                                    //                       FeatherIcons.checkCircle,
                                    //                       color: Colors.white,
                                    //                     )
                                    //                   : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                    //                       strokeWidth: 2,
                                    //                       backgroundColor: Colors.white,
                                    //                     ))
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
                                    data: Theme.of(context).copyWith(
                                        accentColor: Color(0xFF9B049B)),
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              );
            }),
          ));
    },
  );
}
