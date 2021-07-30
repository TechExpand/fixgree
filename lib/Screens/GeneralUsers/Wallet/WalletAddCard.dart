import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

class WalletAddCard extends StatefulWidget {
  @override
  _WalletAddCardState createState() => _WalletAddCardState();
}

class _WalletAddCardState extends State<WalletAddCard> {
  TextEditingController cardNo = new TextEditingController();
  TextEditingController expiryDate = new TextEditingController();
  TextEditingController cvvCode = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('New Card',
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
          expiryDate.text = snapshot.data['exp_month']+'/'+snapshot.data['exp_year'];
          cvvCode.text = snapshot.data['exp_month'];
          return snapshot.hasData?Column(
            children: [
              Container(
                height: 55,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12),
                margin:
                const EdgeInsets.only(bottom: 15, left: 12, right: 12, top: 15),
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
                            fontFamily: 'Firesans',
                            fontSize: 16,
                            color: Color(0xFF270F33),
                            fontWeight: FontWeight.w600),
                        controller: cardNo,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Card Number',
                          hintStyle: TextStyle(
                              fontFamily: 'Firesans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
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
                              inputFormatters: [
                                CreditCardExpirationDateFormatter()
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontFamily: 'Firesans',
                                  fontSize: 16,
                                  color: Color(0xFF270F33),
                                  fontWeight: FontWeight.w600),
                              controller: expiryDate,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Expiry Date',
                                hintStyle: TextStyle(
                                    fontFamily: 'Firesans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
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
                                  fontFamily: 'Firesans',
                                  fontSize: 16,
                                  color: Color(0xFF270F33),
                                  fontWeight: FontWeight.w600),
                              controller: cvvCode,
                              decoration: InputDecoration.collapsed(
                                hintText: 'CVV',
                                hintStyle: TextStyle(
                                    fontFamily: 'Firesans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
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
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Wrap(
                  children: [
                    Text(
                        'Your card details are secure with Fixme and will not be disclosed for any reason.',
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF9B049B),
                            fontSize: 18,
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
                          'Add Card',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Firesans',
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
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
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
    // valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
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
