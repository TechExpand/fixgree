import 'package:fixme/Screens/LoginSignup/Login.dart';
import 'package:fixme/Screens/LoginSignup/SignUpNumber.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter/material.dart';

// import 'bottomnavbar.dart';

class SelectAuthScreen extends StatefulWidget {
  // SelectAuthScreen({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  SelectAuthScreenState createState() => SelectAuthScreenState();
}

class SelectAuthScreenState extends State<SelectAuthScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text('Fixme', style: TextStyle(color: Color(0xFF9B049B))),

      // ),
      backgroundColor: Color(0xFF9B049B),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              width: deviceSize.width,
              height: deviceSize.height / 2,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Hero(
                  tag: 'MainImage',
                  child: Image.asset(
                    'assets/images/fixme.png',
                    scale: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Text(
                    'Fixme',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Firesans',
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
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
                Text('Get services from your mobile phone.',
                    style: TextStyle(
                        fontFamily: 'Firesans',
                        fontSize: 17,
                        color: Color(0xFFE7E7E7),
                        fontWeight: FontWeight.w600))
              ],
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(
                  top: 10, left: 12, right: 12, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.white,
              ),
              child: new FlatButton(
                padding: EdgeInsets.all(10),
                onPressed: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SignUp();
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                            color: Color(0xFF9B049B),
                            fontFamily: 'Firesans',
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        FeatherIcons.user,
                        color: Color(0xFF9B049B),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              child: new FlatButton(
                padding: EdgeInsets.all(10),
                onPressed: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Login();
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            color: Color(0xFF9B049B),
                            fontFamily: 'Firesans',
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        FeatherIcons.lock,
                        color: Color(0xFF9B049B),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
