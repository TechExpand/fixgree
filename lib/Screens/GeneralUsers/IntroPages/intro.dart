import 'package:fixme/Screens/GeneralUsers/LoginSignup/Login.dart';
import 'package:fixme/Screens/GeneralUsers/LoginSignup/SignUpNumber.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Text(''),
            color: Colors.white,
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.6,
            top: -50,
            child: Container(
              height: 230,
              width: 230,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(200)),
                  color: Color(0xFFF9F9F9)),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.6,
            bottom: -40,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Color(0xFFF9F9F9)),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return Login();
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
                            child: Text('Skip')),
                      )),
                  Container(
                    height: 400,
                    child: PageView(
                      onPageChanged: (value){
                        setState(() {
                          index = value;
                        });
                      },
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 200,
                                child:   Image.asset(
                                  'assets/images/gf1.gif',
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                  width: 220,
                                  child: Text(
                                    'Purchase goods or services securely from people around you',
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 200,
                                child:   Image.asset(
                                  'assets/images/gf2.gif',
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                  width: 200,
                                  child: Text(
                                    'Find the best service providers easily around you',
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                               padding:EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                height: 200,
                                child:   Image.asset(
                                  'assets/images/gf3.gif',
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                  width: 250,
                                  child: Text(
                                    'Payments are secured with our escrow system and only gets remitted to the vendor when the transaction is complete or the products purchased are received',
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                index!=2? Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedContainer(
                            width: index==0?25:8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index==0?Color(0xFF9B049B):Color(0xFFBBBBBB),
                            ),
                              duration: Duration(milliseconds: 400)),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedContainer(
                              width: index==1?25:8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: index==1?Color(0xFF9B049B):Color(0xFFBBBBBB),
                              ),
                              duration: Duration(milliseconds: 400)),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedContainer(
                              width: index==2?25:8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: index==2?Color(0xFF9B049B):Color(0xFFBBBBBB),
                              ),
                              duration: Duration(milliseconds: 400)),
                        ),


                      ],
                    ),
                ):Padding(
                  padding: const EdgeInsets.only(top:0.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child:Container(
                            child: FlatButton(
                              onPressed:() {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return SignUp();
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
                              ,
                              color: Color(0xFF9B049B),
                              disabledColor: Color(0x909B049B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 1.3,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "SIGNUP",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return Login();
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
                              child: Center(
                                  child: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: 'Already have an account? ',
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFF777777), fontSize: 16),
                                        ),
                                        TextSpan(
                                          text: 'Login',
                                          style: GoogleFonts.poppins(
                                              color: Color(0xFF9B049B), fontSize: 16),
                                        )
                                      ]))))),


                    ],
                  ),
                )
                ],
              )),

        ],
      ),
    ));
  }
}
