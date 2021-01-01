import 'package:fixme/Screens/LoginSignup/Login.dart';
import 'package:fixme/Screens/LoginSignup/SignUpNumber.dart';
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
 
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text('Fixme', style: TextStyle(color: Color(0xFF9B049B))),

        // ),
        body:
        
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              Image.asset(
            'assets/images/fixme.png',
            scale: 1.5,
          ),
              SizedBox(height:50),
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
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
                  child: Container(
                    width: 380,
                  decoration: BoxDecoration(
                      color: Color(0xFF9B049B),
                      borderRadius: BorderRadius.circular(26)),
                  height: 50,
                  child: Center(
                      child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  )),
                ),
              ),
              SizedBox(height:25),
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
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
                  child: Container(
                    width: 380,
                  decoration: BoxDecoration(
                      color: Color(0xFF9B049B),
                      borderRadius: BorderRadius.circular(26)),
                  height: 50,
                  child: Center(
                      child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold, fontSize: 15),
                  )),
                ),
              ),


            ],),
          )
        ),
      );
    
  }
}
