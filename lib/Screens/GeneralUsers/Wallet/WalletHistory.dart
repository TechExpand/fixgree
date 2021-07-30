import 'package:flutter/material.dart';
import 'package:fixme/Services/network_service.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Model/TransactionDetails.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:intl/intl.dart';

class WalletHistory extends StatefulWidget {
  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('History',
            style: TextStyle(
                color: Color(0xFF9B049B),
                fontSize: 21,
                height: 1.4,
                fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            // height: deviceSize.height,
            child: FutureBuilder<List>(
                future: network.getUserTransactions(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  Widget mainWidget;
                  if (snapshot.connectionState == ConnectionState.none) {
                    mainWidget = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Theme(
                              data: Theme.of(context)
                                  .copyWith(accentColor: Color(0xFF9B049B)),
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                 strokeWidth: 2,
                                              backgroundColor: Colors.white,
   //  valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
                          SizedBox(
                            height: 10,
                          ),
                          Text('No Network',
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  } else {
                    if (snapshot.data == null) {
                      mainWidget = Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: Color(0xFF9B049B)),
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                   strokeWidth: 2,
                                              backgroundColor: Colors.white,
   //  valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
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
                        ),
                      );
                    } else {
                      mainWidget = ListView.builder(
                        itemCount: snapshot.data.length,
                        padding:
                            const EdgeInsets.only(top: 10, left: 3, right: 5),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          snapshot.data.sort((a, b) {
                            var ad = DateTime.parse(a['transaction_date']);
                            var bd = DateTime.parse(b['transaction_date']);
                            var s = bd.compareTo(ad);
                            return s;
                          });
                          TransactionDetails transactionDetails =
                              TransactionDetails.fromJson(snapshot.data[index]);
                          return ListTile(
                              leading: Container(
                                height: 43,
                                width: 43,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color(0xFFE1E1E1),
                                ),
                                child: Icon(FeatherIcons.checkCircle),
                              ),
                              title: Text(
                                  transactionDetails
                                      .paymentDescription.capitalizeFirstOfEach,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${DateFormat('MMM dd, y').format(transactionDetails.transactionDate)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w600)),
                              trailing: buildTransactionText(
                                  transactionDetails.transactionType,
                                  '${transactionDetails.amountPaid}',
                                  transactionDetails.currency));
                        },
                      );
                    }
                  }
                  return mainWidget;
                }),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionText(String type, String amount, String currency) {
    Widget text;
    switch (type) {
      case "credit":
        text = RichText(
          text: TextSpan(
            text: '+ ${currencySymbol(currency)}',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                color: Color(0xFF02FF1B),
                fontWeight: FontWeight.w600),
            children: <TextSpan>[
              TextSpan(
                  text: '$amount',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFF02FF1B),
                      fontWeight: FontWeight.w600)),
            ],
          ),
        );
        break;
      case "withdrawal":
        text = RichText(
          text: TextSpan(
            text: '- ${currencySymbol(currency)}',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xFFFF0202),
                fontWeight: FontWeight.w600),
            children: <TextSpan>[
              TextSpan(
                  text: '$amount',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFFFF0202),
                      fontWeight: FontWeight.w600)),
            ],
          ),
        );
        break;
      default:
    }
    return text;
  }
}
