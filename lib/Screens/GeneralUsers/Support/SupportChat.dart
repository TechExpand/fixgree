import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SupportChat extends StatefulWidget {
  SupportChat({Key key}) : super(key: key);

  @override
  _SupportChatState createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF9B049B),
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: deviceSize.width,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35))),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 33),
                  child: Image.asset(
                    'assets/images/fixme.png',
                    height: 70,
                    width: 70,
                  ),
                ),
                // ListView
              ],
            ),
          )),
          Container(
            height: 55,
            padding: const EdgeInsets.only(left: 19),
            margin:
                const EdgeInsets.only(bottom: 15, left: 18, right: 18, top: 5),
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(35))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF270F33),
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type here',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      focusColor: Color(0xFF2B1137),
                      fillColor: Color(0xFF2B1137),
                      hoverColor: Color(0xFF2B1137),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Icon(
                    FeatherIcons.send,
                    color: Color(0xFF9B049B),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
