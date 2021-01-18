import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Widgets/ExpandedText.dart';

class ArtisanPage extends StatefulWidget {
  @override
  ArtisanPageState createState() => ArtisanPageState();
}

class ArtisanPageState extends State<ArtisanPage> {
   
  @override
  Widget build(BuildContext context) {
     var data = Provider.of<Utils>(context, listen:false);
    var network = Provider.of<WebServices>(context, listen: false);
    return Material(
      child: FutureBuilder(
        future: network.getUserInfo(),
        builder: (context, snapshot) {
          return snapshot.hasData?Container(
              margin:  EdgeInsets.only( top: MediaQuery.of(context).size.height*.02),
            child: ListView(
              children: [
              Padding(
                padding: const EdgeInsets.only( left: 18, right:18),
                child: Row(children: [
                  Stack(children: <Widget>[
                          CircleAvatar(
                            child: Text(''),
                            radius: 40,
                            backgroundImage:NetworkImage(
                              network.profile_pic_file_name=='no_picture_upload'||
                                  network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                              'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          Positioned(
                            left: 65,
                            top: 55,
                            child: Container(
                                height: 12,
                                width: 12,
                              decoration: BoxDecoration(
                                  color: Color(0xFFDB5B04), shape: BoxShape.circle),
                              child: Text(''),
                            ),
                          ),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''),
                          Padding(
                            padding: const EdgeInsets.only(left:10.0, bottom: 6,),
                            child: Text('${snapshot.data['firstName']} ${snapshot.data['lastName']}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 6),
                            child: Row(children: [
                              Icon(Icons.pin_drop, color: Color(0xFF9B049B)),
                              Text('Calabar, Nigeria',  style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                              ),
                          ),
                            Padding(
                              padding: const EdgeInsets.only(left:10.0, bottom: 6),
                              child: Text('Unverified',  style: TextStyle(color:  Color(0xFFFF0000).withOpacity(0.75),)),
                            ),
                        ],),

                ],),
              ),

              Padding(
                padding: const EdgeInsets.only(top:22.0, left: 18, right:18),
                child: Text('${snapshot.data['serviceArea']}'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.5),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0, bottom: 13, left: 18, right:18),
                child: Row(children: [
Text('Wholesales Channel'),
SizedBox(width: 10,),
StarRating(
      rating: double.parse(snapshot.data['user_rating'].toString()),
   /// onRatingChanged: (rating) => setState(() => this.rating = rating),
    ),
                ],),
              ),
              Padding(
                padding: const EdgeInsets.only(top:0.0, bottom: 5, left: 18, right:18),
                child: Text('About', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
              ),
               Padding(
                  padding: const EdgeInsets.only(top:0.0, left: 18,bottom: 15, right:18),
                child:ExpandableText('${snapshot.data['bio']}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18,bottom: 8, right:18),
                child: Row(children: [
                      Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed:() {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                     // return SignThankyou();
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
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 125,
                                minHeight: 45.0),
                            alignment: Alignment.center,
                            child: Text(
                              "MESSAGE",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),

                     Container(
                       margin: EdgeInsets.only(left: 10),
                        height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed:data.isExpanded1?() {
                          setState((){
                            data.onExpansionChanged1(false);
                          });
                              }:() {
                          setState((){
                            data.onExpansionChanged1(true);
                          });
                              },
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 125,
                                minHeight: 40.0),
                            alignment: Alignment.center,
                            child: Text(
                              "MORE...",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],),
              ),
               !data.isExpanded1?Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ):Container(),
                !data.isExpanded1?Padding(
                padding: const EdgeInsets.only(top:13.0, bottom: 5, left: 18, right:18),
                child: Text('Business Address', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
              ):Container(),
             !data.isExpanded1? Padding(
                 padding: const EdgeInsets.only(top:5.0, bottom: 15, left: 18, right:18),
                child:  Text('${snapshot.data['businessAddress'].toString().isEmpty?snapshot.data['address']:snapshot.data['businessAddress']}', style: TextStyle(height: 1.5),),
              ):Container(),
          !data.isExpanded1? Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ):Container(),
     !data.isExpanded1?   Padding(
                padding: const EdgeInsets.only(top:13.0, bottom: 5, left: 18, right:18),
                child: Text('SubServices', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
              ):Container(),
              !data.isExpanded1?Padding(
                 padding: const EdgeInsets.only(top:5.0, bottom: 15, left: 18, right:18),
                child: Text('${snapshot.data['subServices'][0]['subservice']}', style: TextStyle(height: 1.5),),
              ):Container(),
           Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ),
!data.isExpanded1? Padding(
                padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
                child: Text('Catalogues(4)', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
              ):Container(),

            !data.isExpanded1?  Container(
                margin: const EdgeInsets.only(bottom:30.0),
                child: Expanded(
                  child: GridView.count(
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
  crossAxisCount: 2,
  children: List.generate(4, (index) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 200,
            child: Image.asset(
                        'assets/images/phone.png',
                        fit: BoxFit.contain,
                      ),
          ),
    );
  }),
),
                ),
              ):Container(),
              //
 Padding(
                padding: const EdgeInsets.only(top:13.0, bottom: 10, left: 18, right:18),
                child: Row(children:[
                  Text('Comments', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
                 Padding(
                    padding:  EdgeInsets.only(top:1, left: 10),
                   child:  Text('230', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color:Color(0xFF444444)),),
                 )
                ]),
              ),
                Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ),

             Padding(
               padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
               child:  Row (
                children: [
                   CircleAvatar(
                            child: Text(''),
                            radius: 22,
                            backgroundImage:NetworkImage(
                              network.profile_pic_file_name=='no_picture_upload'||
                                  network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                              'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          
                       
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''),
                          Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 6),
                            child: Row(children: [
                              Text('Da Vinci'),
                              Container(
                                margin: const EdgeInsets.only(left: 5, right:5),
                                height: 5,
                                width: 5,
                              decoration: BoxDecoration(
                                  color:Color(0xFF444444), shape: BoxShape.circle),
                              child: Text(''),
                            ),
                            Text('3 years ago'),
                              ],
                              ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 4),
                            child: Text('He is the best')), 
                            Padding(
                               padding: const EdgeInsets.only(left:6.8, bottom: 4),
                              child: Row(
                              children:[
                                Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850),size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
                              ]
                            ),
                            )
                        ],),

                ],),
             ),
             
               Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ),
              
             Padding(
               padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
               child:  Row (
                children: [
                   CircleAvatar(
                            child: Text(''),
                            radius: 22,
                            backgroundImage:NetworkImage(
                              network.profile_pic_file_name=='no_picture_upload'||
                                  network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                              'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          
                       
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''),
                          Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 6),
                            child: Row(children: [
                              Text('Da Vinci'),
                              Container(
                                margin: const EdgeInsets.only(left: 5, right:5),
                                height: 5,
                                width: 5,
                              decoration: BoxDecoration(
                                  color:Color(0xFF444444), shape: BoxShape.circle),
                              child: Text(''),
                            ),
                            Text('3 years ago'),
                              ],
                              ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 4),
                            child: Text('He is the best')), 
                            Padding(
                               padding: const EdgeInsets.only(left:6.8, bottom: 4),
                              child: Row(
                              children:[
                                Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850),size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
                              ]
                            ),
                            )
                        ],),

                ],),
             ),
             
               Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ),
             Padding(
               padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
               child:  Row (
                children: [
                   CircleAvatar(
                            child: Text(''),
                            radius: 22,
                            backgroundImage:NetworkImage(
                              network.profile_pic_file_name=='no_picture_upload'||
                                  network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                              'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          
                       
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''),
                          Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 6),
                            child: Row(children: [
                              Text('Da Vinci'),
                              Container(
                                margin: const EdgeInsets.only(left: 5, right:5),
                                height: 5,
                                width: 5,
                              decoration: BoxDecoration(
                                  color:Color(0xFF444444), shape: BoxShape.circle),
                              child: Text(''),
                            ),
                            Text('3 years ago'),
                              ],
                              ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 4),
                            child: Text('He is the best')), 
                            Padding(
                               padding: const EdgeInsets.only(left:6.8, bottom: 4),
                              child: Row(
                              children:[
                                Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850),size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
                              ]
                            ),
                            )
                        ],),

                ],),
             ),
             
               Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ),  Padding(
               padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
               child:  Row (
                children: [
                   CircleAvatar(
                            child: Text(''),
                            radius: 22,
                            backgroundImage:NetworkImage(
                              network.profile_pic_file_name=='no_picture_upload'||
                                  network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                              'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          
                       
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''),
                          Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 6),
                            child: Row(children: [
                              Text('Da Vinci'),
                              Container(
                                margin: const EdgeInsets.only(left: 5, right:5),
                                height: 5,
                                width: 5,
                              decoration: BoxDecoration(
                                  color:Color(0xFF444444), shape: BoxShape.circle),
                              child: Text(''),
                            ),
                            Text('3 years ago'),
                              ],
                              ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 4),
                            child: Text('He is the best')), 
                            Padding(
                               padding: const EdgeInsets.only(left:6.8, bottom: 4),
                              child: Row(
                              children:[
                                Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850),size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
                              ]
                            ),
                            )
                        ],),

                ],),
             ),
             
               Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ),  Padding(
               padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
               child:  Row (
                children: [
                   CircleAvatar(
                            child: Text(''),
                            radius: 22,
                            backgroundImage:NetworkImage(
                              network.profile_pic_file_name=='no_picture_upload'||
                                  network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                              'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          
                       
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''),
                          Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 6),
                            child: Row(children: [
                              Text('Da Vinci'),
                              Container(
                                margin: const EdgeInsets.only(left: 5, right:5),
                                height: 5,
                                width: 5,
                              decoration: BoxDecoration(
                                  color:Color(0xFF444444), shape: BoxShape.circle),
                              child: Text(''),
                            ),
                            Text('3 years ago'),
                              ],
                              ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left:6.8, bottom: 4),
                            child: Text('He is the best')), 
                            Padding(
                               padding: const EdgeInsets.only(left:6.8, bottom: 4),
                              child: Row(
                              children:[
                                Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850),size: 16,),
Icon(Icons.star, color: Color(0xFFFFC850), size: 16,),
                              ]
                            ),
                            )
                        ],),

                ],),
             ),
             
               Material(
             elevation: 1.8,
             child: Container(
                    width: double.infinity,
                    color: Color(0xFF666666).withOpacity(0.5),
                    height: 1,),
           ),
            ],),
          ):Center(
            child:   CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF9B049B))));
        }
      ),
    );
  }
}