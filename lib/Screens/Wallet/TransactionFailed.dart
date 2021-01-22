import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TransactionFailed extends StatefulWidget {
  final String message;

  TransactionFailed({this.message});

  @override
  _TransactionFailedState createState() => _TransactionFailedState();
}

class _TransactionFailedState extends State<TransactionFailed> {
  BorderRadiusGeometry radiusTop = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9B049B),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF9B049B),
      body: Column(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text('Failed!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.w600)),
          )),
          Container(
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: radiusTop),
            width: deviceSize.width,
            height: deviceSize.height / 1.7,
            child: Column(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  margin: const EdgeInsets.only(top: 45),
                  decoration: BoxDecoration(
                    color: Color(0xFF9B049B),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    FeatherIcons.alertCircle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your transaction failed.',
                        style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.w600)),
                    Text('${widget.message} ',
                        style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: FontWeight.w400)),
                  ],
                )),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Color(0xFF9B049B),
                  ),
                  child: new FlatButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Try again',
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
