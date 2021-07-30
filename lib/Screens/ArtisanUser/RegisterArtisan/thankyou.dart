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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading:  IconButton(
          icon:Icon(Icons.keyboard_backspace, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20,),
        child: ListView(
        physics: BouncingScrollPhysics(),
          children: <Widget>[
                 Padding(
                padding: const EdgeInsets.only(top:40.0),
                child:   Image.asset(
              'assets/images/thankyou.png',
              scale: 1.2,
            )),

              Padding(
                padding: EdgeInsets.only( left: 15),
                child: Align(
                  child: Text('Using Fixme for Business',
               style: TextStyle(fontWeight: FontWeight.bold)),
                  alignment: Alignment.bottomLeft,)
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 15),
                child: Align(
                  child: Text('Hi ' + '${network.firstName},',
               style: TextStyle( color: Colors.black)),
                  alignment: Alignment.bottomLeft,)
              ),

                 Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Align(
                  child: RichText(
                   text : TextSpan(
                     children:[
                       TextSpan(
                       text: """Fixme helps connects businesses and service providers to customers. By switching to a business account you are choosing to allow Fixme direct customers to your business or service. To get started, you need to fill out your business details. Select""",
                           style: TextStyle(  height: 1.6,color: Colors.black )
                       ),
                       TextSpan(
                         text: ' I Am an Artisan',
                           style: TextStyle(  height: 1.6,color: Colors.black , fontWeight: FontWeight.bold)
                       ),
                       TextSpan(
                         text: ' if your provide personalized services eg. cleaning, event management, makeup, photography e.t.c',
                           style: TextStyle(  height: 1.6,color: Colors.black )
                       ),
                       TextSpan(
                           text: ' Select I Am a Vendor',
                           style: TextStyle(  height: 1.6,color: Colors.black,  fontWeight: FontWeight.bold )
                       ),
                       TextSpan(
                         text: ' if you sell various items and want your goods or services listed for sale on Fixme. For security reasons Fixme only releases payments when a service is confirmed as completed or goods are confirmed as delivered. Fixme takes a token of 6% for transactions bellow N10,000.00 and 10% for transactions above N10,000.00.',
                           style: TextStyle(  height: 1.6,color: Colors.black )
                       )
                     ]
                   ),
                  ),
                  alignment: Alignment.bottomLeft,)
              ), 
                

                 Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Align(
                  child: Text("To get started, all you need to "
                      "do is fill out a profile.",
                      style: TextStyle(  height: 1.6,color: Colors.black )),
                  alignment: Alignment.bottomLeft,)
              ), 

                
                 Padding(
                   padding: const EdgeInsets.only(bottom:15.0),
                   child: Row(
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
                   ),
                 )
          ],
        ),
      ),
    );
  }
}
