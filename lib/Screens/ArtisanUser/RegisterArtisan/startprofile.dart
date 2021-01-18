import 'package:fixme/Screens/ArtisanUser/ProfileSetUp/profileArtisan.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignStartProfile extends StatefulWidget {
  @override
 SignStartProfileState createState() => SignStartProfileState();
}

class SignStartProfileState extends State<SignStartProfile> {
 
  var password;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
     var network = Provider.of<WebServices>(context);
    return Scaffold(
      
      appBar: AppBar(
        leading: InkWell(
          child:Icon(Icons.arrow_back, color:Color(0xFF9B049B)),
          onTap:(){
            Navigator.pop(context);
          }
        ),
        backgroundColor:Colors.white,
        title: Text('Fill out your profile to apply', style:TextStyle(color:Colors.black, fontSize:16))
      ),
      body: Column(
          children: <Widget>[
                 Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Text("To provide a high quality experience to all customers, admission to fixme is highly competitive",
                  style: TextStyle(  height: 1.6, fontWeight: FontWeight.w500 )
                  ),
                  alignment: Alignment.bottomLeft,)
              ), 
                

                 Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Text("Here’s how it works:"),
                  alignment: Alignment.bottomLeft,)
              ), 
               Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: 
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(
                                   '1.  ',
                                    style: TextStyle(
                                      
                                      color: Colors.black)
                                    ),
                                Expanded(
                                  child: Text(
                                    'Fill out your profile thoroughly and accurately',
                                    style: TextStyle(
                                      
                                      color: Colors.black)),
                                )
                              
                              ]),
                              
                  alignment: Alignment.bottomLeft,)
              ), 

               Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child:   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                Text(
                                     '2.  ',
                                    style: TextStyle(
                                      
                                      color: Colors.black)
                                    ),
                                Expanded(child:Text(
                                     'Submit your profile',
                                    style: TextStyle(
                                      
                                      color: Colors.black))),
                              
                              ]),
                  alignment: Alignment.bottomLeft,)
              ), 
        Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                Text(
                                     '3.  ',
                                    style: TextStyle(
                                      
                                      color: Colors.black)
                                    ),
                                Expanded(
                                  child: Text(
                                    'You’ll receive an email within 24 hours to let you know if you were accepted',
                                    style: TextStyle(
                                      
                                      color: Colors.black)),
                                )
                              
                              ]),
                  alignment: Alignment.bottomLeft,)
              ), 
               Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Text("Create a stand-out profile to increase your chance of getting a job and also get trust from clients.",
                  style: TextStyle(  height: 1.6, )
                  ),
                  alignment: Alignment.bottomLeft,)
              ), 
                Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  top:40,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(26)),
                child: FlatButton(
                 
                  disabledColor: Color(0x909B049B),
                  onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SignUpProfileSetupPage();
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
                  color: Color(0xFF9B049B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(26)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.3,
                          minHeight: 45.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Start My Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ), 
                
          ],
        )
    );
      
  }
}
