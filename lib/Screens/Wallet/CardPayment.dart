import 'package:flutter/material.dart';
import 'package:fixme/Screens/Wallet/SeeBeneficiaries.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CardPayment extends StatefulWidget {
  CardPayment({Key key}) : super(key: key);

  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  @override
  Widget build(BuildContext context) {
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
      body: ListView(physics: BouncingScrollPhysics(), children: [
        Container(
          height: 140,
          margin: const EdgeInsets.only(top: 20, right: 5),
          alignment: Alignment.center,
          child: Image.asset('assets/images/fixme.png'),
        ),
        Row(
          children: [
            Container(
              width: 20.0,
              height: 40.0,
              color: Colors.transparent,
            ),
            Text('Enter card details',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600))
          ],
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12),
          margin:
              const EdgeInsets.only(bottom: 10, left: 12, right: 12, top: 5),
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border.all(color: Color(0xFFF1F1FD)),
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
              Expanded(
                child: TextFormField(
                  inputFormatters: [CreditCardNumberInputFormatter()],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF270F33),
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Amount',
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    focusColor: Color(0xFF2B1137),
                    fillColor: Color(0xFF2B1137),
                    hoverColor: Color(0xFF2B1137),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12),
          margin:
              const EdgeInsets.only(bottom: 10, left: 12, right: 12, top: 5),
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border.all(color: Color(0xFFF1F1FD)),
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
              Expanded(
                child: TextFormField(
                  inputFormatters: [CreditCardNumberInputFormatter()],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF270F33),
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Account number',
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SeeBeneficiaries();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Text('Choose beneficiary',
                    style: TextStyle(
                        color: Color(0xFF9B049B),
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 20.0,
              height: 40.0,
              color: Colors.transparent,
            ),
            Text('Input your card details',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600))
          ],
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12),
          margin: const EdgeInsets.only(bottom: 15, left: 12, right: 12),
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border.all(color: Color(0xFFF1F1FD)),
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
                  FeatherIcons.creditCard,
                  color: Color(0xFF555555),
                  size: 20,
                ),
              ),
              Expanded(
                child: TextFormField(
                  inputFormatters: [CreditCardNumberInputFormatter()],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF270F33),
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Card Number',
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
          children: [
            Expanded(
              child: Container(
                height: 55,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12),
                margin: const EdgeInsets.only(
                    bottom: 15, left: 12, right: 12, top: 5),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    // border: isAppEmpty ? Border.all(color: Colors.red) : null,
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
                        FeatherIcons.calendar,
                        color: Color(0xFF555555),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [CreditCardExpirationDateFormatter()],
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF270F33),
                            fontWeight: FontWeight.w600),
                        // controller: expiryDate,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Expiry Date',
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
            ),
            Expanded(
              child: Container(
                height: 55,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12),
                margin: const EdgeInsets.only(
                    bottom: 15, left: 12, right: 12, top: 5),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    // border: isAppEmpty ? Border.all(color: Colors.red) : null,
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
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF270F33),
                            fontWeight: FontWeight.w600),
                        // controller: cvvCode,
                        decoration: InputDecoration.collapsed(
                          hintText: 'CVV',
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
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Wrap(
            children: [
              Text(
                  'Your card details are secure with Fixme and will not be disclosed for any reason.',
                  softWrap: true,
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          height: 50,
          margin:
              const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 20),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Complete transaction',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
