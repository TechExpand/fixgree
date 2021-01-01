import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class WalletHistory extends StatefulWidget {
  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('History',
            style: TextStyle(
                color: Color(0xFF9B049B),
                fontSize: 21,
                fontFamily: 'Firesans',
                height: 1.4,
                fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft,
              color: Color(0xFF9B049B)),
        ),
        elevation: 0,
      ),
    );
  }
}
