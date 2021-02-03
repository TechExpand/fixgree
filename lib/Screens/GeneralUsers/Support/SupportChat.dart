import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
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
            ),
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
                Expanded(
                  // height: 100,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Tawk(
                      directChatLink:
                          'https://tawk.to/chat/60141f68c31c9117cb73db41/1et79lcnl',
                      visitor: TawkVisitor(
                        name: 'Emmanuel Joshua',
                        email: 'emmanueljoshua145@gmail.com',
                      ),
                      onLoad: () {
                        print('Hello Tawk!');
                      },
                      onLinkTap: (String url) {
                        print(url);
                      },
                      placeholder: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: Color(0xFF9B049B)),
                                child: CircularProgressIndicator()),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Loading',
                                style: TextStyle(
                                    // letterSpacing: 4,
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
          // Container(
          //   height: 55,
          //   padding: const EdgeInsets.only(left: 19),
          //   margin:
          //       const EdgeInsets.only(bottom: 15, left: 18, right: 18, top: 5),
          //   decoration: BoxDecoration(
          //       color: Color(0xFFFFFFFF),
          //       borderRadius: BorderRadius.all(Radius.circular(35))),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //         child: TextFormField(
          //           textCapitalization: TextCapitalization.sentences,
          //           style: TextStyle(
          //               fontSize: 16,
          //               color: Color(0xFF270F33),
          //               fontWeight: FontWeight.w600),
          //           decoration: InputDecoration.collapsed(
          //             hintText: 'Type here',
          //             hintStyle:
          //                 TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //             focusColor: Color(0xFF2B1137),
          //             fillColor: Color(0xFF2B1137),
          //             hoverColor: Color(0xFF2B1137),
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(right: 17),
          //         child: Icon(
          //           FeatherIcons.send,
          //           color: Color(0xFF9B049B),
          //           size: 24,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
