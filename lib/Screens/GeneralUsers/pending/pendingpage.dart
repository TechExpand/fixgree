
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';


class PendingScreen extends StatefulWidget {
  var scafold_key;

  PendingScreen(this.scafold_key);

  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
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
                      child:  Padding(
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
                Container(
                    margin: const EdgeInsets.only(top:20.0, bottom: 20.0),
                  height: 67,
                  width: MediaQuery.of(context).size.width*0.92,
            child: Card(color: Color(0xFF9B049B),
              child: Center(child: 
                   RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Wallet  Balance ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                TextSpan(
                                    text: '₦19, 750',
                                    style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Colors.white)),
                              
                              ])),
                    
                  ),),),
              
               Column(
                 children: [
                   Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '22 july 2018',
                            style: TextStyle(color: Colors.black38,  fontSize: 13,),
                          ),
                          Text('BALANCE N19, 750',
                              style: TextStyle(color: Colors.black38, fontSize: 13,))
                        ],
                      ),
                    ),

               Slidable(
                 actions: <Widget>[
     IconSlideAction(
      color: Colors.red,
      iconWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('SERVICES', style:TextStyle(color:Colors.white, fontSize: 11,fontWeight: FontWeight.bold)),
        Text('REJECTED', style:TextStyle(color:Colors.white, fontSize: 11, fontWeight: FontWeight.bold))],
      ),
      onTap: () => print('ddd'),
    ),
  ],
  secondaryActions: <Widget>[
    IconSlideAction(
      color: Color(0xFF27AE60),
      iconWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('EXPENSES', style:TextStyle(color:Colors.white, fontSize: 11,fontWeight: FontWeight.bold)),
        Text('COMPLETED', style:TextStyle(color:Colors.white, fontSize: 11, fontWeight: FontWeight.bold))],
      ),
      onTap: () => print('more'),
    ),
    
  ],
                  actionPane: SlidableDrawerActionPane(),
                   actionExtentRatio: 0.25,
                child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFF9B049B), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFA40C85).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Designing your logo',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Vincent Rollins',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '- ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↓',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red)),
                              
                              ])),
                          
                        ],
                      ),
                    )),
                    


                     Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFFDB5B04), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFDB5B04).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Repaired generator',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Alahji Musa J.',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '+ ',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↑',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                 Padding(
                    padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                   child: Divider(),
                 )
                 ],
               ),


                Column(
                 children: [
                   Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '22 july 2018',
                            style: TextStyle(color: Colors.black38,  fontSize: 13,),
                          ),
                          Text('BALANCE N19, 750',
                              style: TextStyle(color: Colors.black38, fontSize: 13,))
                        ],
                      ),
                    ),

               Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Food', style:TextStyle(color: Color(0xFF9B049B), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFA40C85).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Baking/Food delivery',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Spicy Catering Ltd',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '- ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      )),
                                TextSpan(
                                    text: 'N12, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↓',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                    


                     Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Clothing', style:TextStyle(color: Color(0xFFDB5B04), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFDB5B04).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Fashion/Textile Retain',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Gee fashion Inc',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '+ ',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↑',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                 Padding(
                    padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                   child: Divider(),
                 )
                 ],
               ),




                Column(
                 children: [
                   Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '22 july 2018',
                            style: TextStyle(color: Colors.black38,  fontSize: 13,),
                          ),
                          Text('BALANCE N19, 750',
                              style: TextStyle(color: Colors.black38, fontSize: 13,))
                        ],
                      ),
                    ),

               Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFF9B049B), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFA40C85).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Designing your logo',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Vincent Rollins',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '- ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↓',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                    


                     Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFFDB5B04), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFDB5B04).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Repaired generator',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Alahji Musa J.',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '+ ',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↑',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                 Padding(
                    padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                   child: Divider(),
                 )
                 ],
               ),




                Column(
                 children: [
                   Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '22 july 2018',
                            style: TextStyle(color: Colors.black38,  fontSize: 13,),
                          ),
                          Text('BALANCE N19, 750',
                              style: TextStyle(color: Colors.black38, fontSize: 13,))
                        ],
                      ),
                    ),

               Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFF9B049B), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFA40C85).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Designing your logo',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Vincent Rollins',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '- ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↓',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                    


                     Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFFDB5B04), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFDB5B04).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Repaired generator',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Alahji Musa J.',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '+ ',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↑',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                 Padding(
                    padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                   child: Divider(),
                 )
                 ],
               ),


                Column(
                 children: [
                   Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '22 july 2018',
                            style: TextStyle(color: Colors.black38,  fontSize: 13,),
                          ),
                          Text('BALANCE N19, 750',
                              style: TextStyle(color: Colors.black38, fontSize: 13,))
                        ],
                      ),
                    ),

               Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFF9B049B), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFA40C85).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Designing your logo',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Vincent Rollins',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '- ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↓',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                    


                     Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      child: Row(
                       
                        children: [
                           Container(
                    height: 26,
                    child: Center(child: Text('Design', style:TextStyle(color: Color(0xFFDB5B04), fontWeight: FontWeight.bold))),
                    width: 73,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFDB5B04).withOpacity(0.35),
                    
                    )),
                     Padding(
                       padding: const EdgeInsets.only(left:10.0),
                       child: Column(
                         crossAxisAlignment:CrossAxisAlignment.start ,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom:4.0),
                             child: Text('Repaired generator',
                                      style: TextStyle(color: Colors.black)),
                           ),
                           Text('Alahji Musa J.',
                                    style: TextStyle(color: Colors.black, fontSize: 13)),
                         ],
                       ),
                     ),
                     Spacer(),

  RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '+ ',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      )),
                                TextSpan(
                                    text: 'N2, 200',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                TextSpan(
                                    text: ' ↑',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green)),
                              
                              ])),
                          
                        ],
                      ),
                    ),
                 Padding(
                    padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                   child: Divider(),
                 )
                 ],
               ),
            
            ]),
          ),
        )
      ],
    );
  }
}




