import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/startprofile.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignThankyou extends StatefulWidget {
  @override
 SignThankyouState createState() => SignThankyouState();
}

class SignThankyouState extends State<SignThankyou> {
  var password;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
     var network = Provider.of<WebServices>(context);
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20,),
        child: Column(
        
          children: <Widget>[
                 Padding(
                padding: const EdgeInsets.only(top:90.0),
                child:   Image.asset(
              'assets/images/thankyou.png',
              scale: 1.2,
            )),

              Padding(
                padding: EdgeInsets.only(top: 40, left: 15),
                child: Align(
                  child: Text('Join Fixme as an Artisan',
               style: TextStyle(fontWeight: FontWeight.bold)),
                  alignment: Alignment.bottomLeft,)
              ),

              Padding(
                padding: EdgeInsets.only(top: 30, left: 15),
                child: Align(
                  child: Text('Hi ' + '${network.firstName},',
               style: TextStyle( color: Colors.black)),
                  alignment: Alignment.bottomLeft,)
              ),

                 Padding(
                padding: EdgeInsets.only(top: 30, left: 15),
                child: Align(
                  child: Text("Thanks for your interest in fixme! As the Country largest platform, we connect millions of businesse with independent professonals like you.",
                  style: TextStyle(  height: 1.6 )
                  ),
                  alignment: Alignment.bottomLeft,)
              ), 
                

                 Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Text("To get started, all you need to do is fill out a profile."),
                  alignment: Alignment.bottomLeft,)
              ), 

                
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Padding(
                       padding: EdgeInsets.only(top: 50,left: 15),
                       child:  InkWell(
                          onTap: (){
                            data.setArtisanVendorChoice('artisan');
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SignStartProfile();
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
                         child:Text("Are you an Artisan?", style: TextStyle(color:Color(0xFF9B049B),)),
                     )),
                    
                     Padding(
                       padding: EdgeInsets.only(top: 50, right: 15),
                       child: InkWell(
                         onTap: (){
                            data.setArtisanVendorChoice('business');
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SignStartProfile();
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
                         child: Text("Are you an Vendor?", style: TextStyle(color:Color(0xFF9B049B),))),
                     )
                   ]
                 )
          ],
        ),
      ),
    );
  }
}
