import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
import 'package:fixme/Widgets/ExpandedText.dart';
import 'package:fixme/Widgets/Rating.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return WillPopScope(
      onWillPop: (){
     return   Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) {
              return  HomePage();
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
      child: Material(
        child: FutureBuilder(
          future: network.getUserInfo(network.user_id),
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

                              snapshot.data['identificationStatus']=='un-verified'? Padding(
                                padding: const EdgeInsets.only(left:10.0, bottom: 6),
                                child: Text('Unverified',  style: TextStyle(color:  Color(0xFFFF0000).withOpacity(0.75),)),
                              ): Padding(
                                padding: const EdgeInsets.only(left:10.0, bottom: 6),
                                child: Text('Verified',  style: TextStyle(color:  Color(0xFF27AE60).withOpacity(0.9),)),
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
                  child: ExpandableText('${snapshot.data['bio']}',
                  ),
                ),
                 Material(
               elevation: 1.8,
               child: Container(
                      width: double.infinity,
                      color: Color(0xFF666666).withOpacity(0.5),
                      height: 1,),
             ),
                  Padding(
                  padding: const EdgeInsets.only(top:13.0, bottom: 5, left: 18, right:18),
                  child: Text('Business Address', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
                ),
                Padding(
                   padding: const EdgeInsets.only(top:5.0, bottom: 15, left: 18, right:18),
                  child: Text('${snapshot.data['businessAddress'].toString().isEmpty?snapshot.data['address']:snapshot.data['businessAddress']}', style: TextStyle(height: 1.5),),
                ),
             Material(
               elevation: 1.8,
               child: Container(
                      width: double.infinity,
                      color: Color(0xFF666666).withOpacity(0.5),
                      height: 1,),
             ),
              Padding(
                  padding: const EdgeInsets.only(top:13.0, bottom: 5, left: 18, right:18),
                  child: Text('SubServices', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
                ),
                Padding(
                   padding: const EdgeInsets.only(top:5.0, bottom: 15, left: 18, right:18),
                  child: Text('${snapshot.data['subServices'][0]['subservice']}', style: TextStyle(height: 1.5),),
                ),
             Material(
               elevation: 1.8,
               child: Container(
                      width: double.infinity,
                      color: Color(0xFF666666).withOpacity(0.5),
                      height: 1,),
             ),
                      snapshot.data['role']=='artisan'?FutureBuilder(
   future: network.getServiceImage(network.user_id),
   builder: (context, snapshot) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start ,
       children: [
         Padding(
               padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
              child: Text('Catalogues(${snapshot.data==null?0:snapshot.data.length})', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),

                        ),
         Container(
           margin: const EdgeInsets.only(bottom:30.0,  left: 8, right:8),
           child:  GridView.builder(
             shrinkWrap: true,
             physics: ScrollPhysics(),
             itemCount: snapshot.data==null?0:snapshot.data.length,
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,  crossAxisSpacing: 10,
               mainAxisSpacing: 10,),
             itemBuilder: (BuildContext context, int index){
               return InkWell(
                 onTap: (){
                   Navigator.push(
                     context,
                     PageRouteBuilder(
                       pageBuilder: (context, animation, secondaryAnimation) {
                         return PhotoView(
                             'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                           snapshot.data[index]['imageFileName'],
                         );
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
                 child: Hero(
                   tag: snapshot.data[index]['imageFileName'],
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(10),
                     child: Container(
                         width: 200,
                         child: Image.network('https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                           fit: BoxFit.cover,
                         )),
                   ),
                 ),
               );
             },
           )
         ),
       ],
     );
   }
 ):FutureBuilder(
                          future: network.getProductImage(network.user_id),
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:13.0, bottom: 7, left: 18, right:18),
                                  child: Text('Catalogues(${snapshot.data==null?0:snapshot.data.length})', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),

                                ),
                                Container(
                                    margin: const EdgeInsets.only(bottom:30.0,  left: 8, right:8),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount:snapshot.data==null?0:snapshot.data.length,
                                      itemBuilder: (BuildContext context, int index){
                                        return    ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            child: ListTile(
                                              title: Text("${snapshot.data[index]['product_name']}", style: TextStyle(color: Colors.black)),
                                              subtitle: Text("${snapshot.data[index]['price']}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                              trailing: Text('${snapshot.data[index]['status']}'),
                                            ),
                                          ),
                                        );

                                      },
                                    )
                                ),
                              ],
                            );
                          }
                      ),



              ],),
            ):Center(
              child:   CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF9B049B))));
          }
        ),
      ),
    );
  }
}