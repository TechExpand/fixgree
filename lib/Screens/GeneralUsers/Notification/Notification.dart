
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NotificationPage extends StatefulWidget {
  var scafold_key;

  NotificationPage(this.scafold_key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  var search;

  @override
  Widget build(BuildContext context) {
     var network = Provider.of<WebServices>(context, listen: false);
    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Container(
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.scafold_key.currentState.openDrawer();
                      },
                      child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(children: <Widget>[
                    CircleAvatar(
                      child: Text(''),
                      radius: 19,
                      backgroundImage:NetworkImage(
                        network.profile_pic_file_name=='no_picture_upload'||
                            network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                        'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      left: 25,
                      top: 24,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFDB5B04), shape: BoxShape.circle),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ]),
                ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 9, left: 1),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 35,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SearchPage();
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
                        },
                        child: TextFormField(
                            obscureText: true,
                            enabled: false,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelStyle: TextStyle(color: Colors.black38),
                              labelText: 'What are you looking for?',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                            )),
                      ),
                    ),
                    InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ListenIncoming();
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                   padding: const EdgeInsets.only(top:15.0, bottom:8, right:13),
                  child: Icon(
                    Icons.chat,
                    color:Color(0xFF9B049B),
                    size: 25,
                  ),
                ),
              ),
                  ])),
          elevation: 4,
          backgroundColor: Colors.white,
          forceElevated: true,
        ),
        SliverFillRemaining(
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Align(alignment: Alignment.topLeft, child: Text('Recent')),
              ),
              Material(
                color: Colors.white,
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(top: 9, left: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.person_pin,
                          size: 36,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Hassam ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: 'just',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: ' accepted your job',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                    text:
                                    ' proposal, for a generator repair at Lekki, Island',
                                    style: TextStyle(color: Colors.black))
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 12),
                              width: 105,
                              height: 28,
                              child: Center(
                                  child: Text('VIEW PROFILE',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFA40C85),
                                          fontWeight: FontWeight.w500))),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFA40C85)),
                                  borderRadius: BorderRadius.circular(4)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.095,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              '50m',
                              style: TextStyle(color: Colors.black38),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              SizedBox(height: 2),
              Material(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE5E5E5),
                  ),
                  padding: EdgeInsets.only(top: 9, left: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.person_pin,
                          size: 36,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Halabi ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: 'just',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: ' uploaded a picture',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                    text:
                                    ' for a recent job he did at Sattelite town, Calabar.',
                                    style: TextStyle(color: Colors.black))
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 12),
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 65,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 65,
                                      width: 65,
                                      color: Colors.red,
                                      child: Text(''),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Text(
                                            '"Fixing thing and making my client ...'))
                                  ]),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(children: [
                                Text('120 Reactions',
                                    style: TextStyle(color: Colors.black)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.brightness_1,
                                    size: 6,
                                    color: Colors.black,
                                  ),
                                ),
                                Text('4 Comments',
                                    style: TextStyle(color: Colors.black)),
                              ]),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.095,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              '2h',
                              style: TextStyle(color: Colors.black38),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              SizedBox(height: 2),
              Material(
                color: Colors.white,
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(top: 9, left: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.person_pin,
                          size: 36,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Daniel ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: 'is a new',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: ' Artisan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                    text: ' in your area,',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: ' Ikot Ansa, Calabar.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                    text: ' will you want to hire him.',
                                    style: TextStyle(color: Colors.black)),
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 12),
                              width: 105,
                              height: 28,
                              child: Center(
                                  child: Text('VIEW PROFILE',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFA40C85),
                                          fontWeight: FontWeight.w500))),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFA40C85)),
                                  borderRadius: BorderRadius.circular(4)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.095,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              '12h',
                              style: TextStyle(color: Colors.black38),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              SizedBox(height: 2),
              Material(
                color: Colors.white,
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(top: 9, left: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.person_pin,
                          size: 36,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "D'Prince ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: 'just',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: ' Messaged',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                    text: ' you',
                                    style: TextStyle(color: Colors.black))
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 12),
                              width: 105,
                              height: 28,
                              child: Center(
                                  child: Text('REPLY',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFA40C85),
                                          fontWeight: FontWeight.w500))),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFA40C85)),
                                  borderRadius: BorderRadius.circular(4)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.095,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              '50m',
                              style: TextStyle(color: Colors.black38),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Material(
                color: Colors.white,
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(top: 9, left: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.person_pin,
                          size: 36,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Hassam ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: 'just',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: ' accepted your job',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                    text:
                                    ' proposal, for a generator repair at Lekki, Island',
                                    style: TextStyle(color: Colors.black))
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, bottom: 12),
                              width: 105,
                              height: 28,
                              child: Center(
                                  child: Text('VIEW PROFILE',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFA40C85),
                                          fontWeight: FontWeight.w500))),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFA40C85)),
                                  borderRadius: BorderRadius.circular(4)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.095,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              '50m',
                              style: TextStyle(color: Colors.black38),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }
}
