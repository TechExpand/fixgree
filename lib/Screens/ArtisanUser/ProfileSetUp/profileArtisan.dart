import 'package:fixme/Screens/ArtisanUser/ProfileSetUp/Expertise.dart';
import 'package:fixme/Screens/ArtisanUser/ProfileSetUp/Overview.dart';
import 'package:fixme/Screens/ArtisanUser/ProfileSetUp/ProductCartalog.dart';
import 'package:fixme/Screens/ArtisanUser/ProfileSetUp/ServicesCatelog.dart';
import 'package:fixme/Screens/ArtisanUser/ProfileSetUp/ProductDetail.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/bvn.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ProfilePhoto.dart';


class SignUpProfileSetupPage extends StatefulWidget {
  @override
  SignUpProfileSetupPageState createState() => SignUpProfileSetupPageState();
}

class SignUpProfileSetupPageState extends State<SignUpProfileSetupPage> {
  var password;
   String text = 'Expertise';
 int selected = 10;
 String position = '1';
  PageController _myPage;
 
  @override
  void initState() {
    super.initState();
    _myPage =
        PageController(initialPage: 0, viewportFraction: 0.9, keepPage: true);
      
  }


  @override
  Widget build(BuildContext context) {
   var network = Provider.of<WebServices>(context);
    var data = Provider.of<DataProvider>(context);
    return Material(
      child: Container(
        padding:  EdgeInsets.only( top: MediaQuery.of(context).size.height*.065),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
             padding: const EdgeInsets.only(bottom: 6.0,  left: 15, right:15),
              child: Row(
                children: [
                  InkWell(
                    onTap:(){
                      selected==10? (){
                       
                        }:selected==20? _myPage.jumpToPage(0):selected==30? _myPage.jumpToPage(1):_myPage.jumpToPage(2);
                    },
                    child: Icon(Icons.arrow_back, color:Color(0xFF9B049B))),
                  Padding(
                     padding: const EdgeInsets.only( left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        '${text}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
              ),

               Text(
                        '$position of 4',
                        style: TextStyle(
                          fontSize: 15,
                          
                        ),
                        
              ), 

            
                      ],
                    ),
                  ),
                  
                  Spacer(),
                    /*CircleAvatar(
                      child: Icon(Icons.person, color:Colors.white, size: 32,),
                      radius: 19,
                      foregroundColor: Color(0xFFDB5B04).withOpacity(0.75),
                      backgroundColor: Color(0xFFDB5B04).withOpacity(0.75),
                    ),*/
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
                ],
              ),
            ),
            Row(
              children: [
                AnimatedContainer(
          width: selected == 10 ? MediaQuery.of(context).size.width*0.2 : selected==20?MediaQuery.of(context).size.width*0.4:selected==30?MediaQuery.of(context).size.width*0.6:MediaQuery.of(context).size.width,
          height: 10.0,
          color: Color(0xFF9B049B),
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Text(''),
        ),
         AnimatedContainer(
          width: selected == 10 ? MediaQuery.of(context).size.width*0.8:selected== 20?MediaQuery.of(context).size.width*0.6:selected==30?MediaQuery.of(context).size.width*0.4: 0,
          height: 10.0,
          color:   Color(0xFF9B049B).withOpacity(0.5),
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Text(''),
        ),
              ],
            ),
      
          Container(
            height: MediaQuery.of(context).size.height*0.80,
            child: PageView(
            
               controller: _myPage,
               onPageChanged: (value){
                 if(value == 0){

           setState(() {
             text  = 'Expertise';
             selected = 10;
             position = '1';
           });
           
         }else if(value == 1){
           setState(() {
             text  = 'Overview';
             selected = 20;
             position = '2';
           });
              }else if(value == 2){
           setState(() {
             text  = 'Profile Photo';
             selected = 30;
              position = '3';
           });
              }else if(value == 3){
           setState(() {
             text  = 'Catalog';
             selected = 40;
              position = '4';
           });
              }
               },
          //physics: NeverScrollableScrollPhysics(),
              children: data.artisanVendorChoice=='business' ?[
               ProductDetailPage(_myPage),
                OverviewPage(_myPage),
                ProfilePhotoPage(_myPage),
               ProductCatelogPage(_myPage),
               
              ]:[
                ExpertisePage(_myPage),
                OverviewPage(_myPage),
                ProfilePhotoPage(_myPage),
               PhotoCatelogPage(_myPage),
              
              ],
            ),
          )
          ],
        ),
      ),
    );
  }
}
