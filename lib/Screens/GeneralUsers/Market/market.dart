import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Model/Product.dart';
import 'package:fixme/Screens/GeneralUsers/Notification/Notification.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:http/http.dart' as http;
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chat.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../strings.dart';

class MarketPage extends StatefulWidget {
  final scafoldKey;
  final control;

   MarketPage(this.scafoldKey, this.control);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List<Product> market;
  ScrollController scrollController = ScrollController();

  callmarket(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.getMarket().then((value) {
      setState(() {
        market = value ;

      });
    });
  }



  Future<dynamic> getNextMarket() async {
    var utils = Provider.of<Utils>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    try{
    String mainUrl = 'https://manager.fixme.ng';
    var response = await http
        .post(Uri.parse('$mainUrl/load-more-explore-products'), body: {
      'user_id': network.userId.toString(),
      'highestId':  market.length.toString(),
    }, headers: {
      "Content-type": "application/x-www-form-urlencoded",
      'Authorization': 'Bearer ${network.bearer}',
    });
    var body1 = json.decode(response.body);
    print(body1);
    print(body1);
    List body = body1['products'];
    List<Product> projects = body
        .map((data) {
      return Product.fromJson(data);
    })
        .toSet()
        .toList();

    if (body1['reqRes'] == 'true') {
      setState(() {
        utils.setLoading(false);
        market.addAll(projects);
      });
    } else if (body1['reqRes'] == 'false') {
      utils.setLoading(false);
      print(body1);
    }}catch(e){
      utils.setLoading(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var utils = Provider.of<Utils>(context, listen: false);
    utils.setLoading(false);
    scrollController.addListener(()async{

      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels){
        var utils = Provider.of<Utils>(context, listen: false);
        utils.setLoading(true);
        getNextMarket();
      }
    });


    callmarket(context);
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    network.updateFCMToken(network.userId, data.fcmToken);
  }


  @override
  Widget build(BuildContext context) {

    var network = Provider.of<WebServices>(context, listen: false);
    List<Notify> notify;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        elevation: 2.5,
        shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:4.0, bottom: 4, left:10),
              child: IconButton(
                onPressed: (){
                  widget.scafoldKey.currentState.openDrawer();
                },
                icon: Icon(MyFlutterApp.hamburger,
                    size: 17, color: Colors.black),
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/images/fixme1.png',
              height: 70,
              width: 70,
            ),
            Spacer(),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) {
                      return NotificationPage(widget.scafoldKey, widget.control);
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
                padding: const EdgeInsets.only(top: 5,right: 10, left:5),
                child: Stack(
                  children: [
                    Icon(
                      MyFlutterApp.vector_4,
                      color:  Color(0xF0A40C85),
                      size: 24,),
                    StreamBuilder(
                        stream: FirebaseApi.userCheckNotifyStream(
                            network.userId.toString()),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            notify = snapshot.data.docs
                                .map((doc) =>
                                Notify.fromMap(doc.data(), doc.id))
                                .toList();

                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Positioned(
                                    left: 12,
                                    child: Container());
                              default:
                                if (snapshot.hasError) {
                                  return Positioned(
                                      left: 12,
                                      child: Container());
                                } else {
                                  final users = notify;
                                  if (users.isEmpty || users == null) {
                                    return Positioned(
                                        left: 12,
                                        child: Container());
                                  } else {
                                    return Positioned(
                                        left: 12,
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                          size: 12,
                                        ));
                                  }
                                }
                            }
                          } else {
                            return Positioned(
                                left: 12,
                                child: Container());
                          }
                        }),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) {
                      return ListenIncoming();
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

                FirebaseApi.clearCheckChat(
                  network.mobileDeviceToken
                      .toString(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top:8.0, bottom: 8, right: 16, left: 16),
                child:  Stack(
                  children: [
                    Icon(
                        MyFlutterApp.fill_1,
                        size: 23, color: Color(0xF0A40C85)),
                    Icon(Icons.more_horiz, size: 23, color: Colors.white,),
                    StreamBuilder(
                        stream: FirebaseApi.userCheckChatStream(
                            network.mobileDeviceToken.toString()),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            notify = snapshot.data.docs
                                .map((doc) =>
                                Notify.fromMap(doc.data(), doc.id))
                                .toList();

                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Positioned(
                                    right: 12, child: Container());
                              default:
                                if (snapshot.hasError) {
                                  return Positioned(
                                      right: 12, child: Container());
                                } else {
                                  final users = notify;
                                  if (users.isEmpty || users == null) {
                                    return Positioned(
                                        left: 12, child: Container());
                                  } else {
                                    return Container(
                                      margin: EdgeInsets.only(left: 12),
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(100)
                                      ),
                                    );
                                  }
                                }
                            }
                          } else {
                            return Positioned(
                                right: 12, child: Container());
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: market==null?Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Theme(
              data: Theme.of(context).copyWith(
                accentColor: Color(0xFF9B049B),),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                strokeWidth: 2,
                backgroundColor: Colors.white,
                //  valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
              )),
          SizedBox(
            height: 10,
          ),
          Text('Loading',
              style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
        ],
      )):market.isEmpty? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("No Product Available", style: TextStyle(
              color: Colors.black,
              fontSize: 21,
              height: 1.4,
              fontWeight: FontWeight.w500)),),
        ],
      ):Consumer<Utils>(
        builder: (context, utils, child) {
          return Container(
            padding: EdgeInsets.all(5),
            child:  Container(
              child: Stack(
                children: [
                  StaggeredGridView.countBuilder(
                      controller: scrollController,
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      itemCount: market.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            _viewProduct(market[index].user, data: market[index]);
                          },
                          child: Container(
                           // height: 100,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(18))
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(18)),
                              child: Card(
                                child: GridTile(
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: market[index].productImages==null?'':"https://uploads.fixme.ng/thumbnails/${market[index].productImages[0]['imageFileName']}",fit: BoxFit.cover,),
                                  footer: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Column(
                                        children: [
                                          Text("${market[index].product_name}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                           softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text("₦${market[index].price}", style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                      }),
                  utils.isLoading?Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Theme(
                          data: Theme.of(context).copyWith(
                            accentColor: Color(0xFF9B049B),),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                              //  valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
                            ),
                          )),
                    ),
                  ):Container()
                ],
              ),
            ),
          );
        }
      ),
    );
  }







  _viewProduct(userData, {data}) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return  Scaffold(
            appBar:  PreferredSize(
              preferredSize: Size(double.infinity, 80),
              child: Container(
                height: 80,
                child: Stack(
                  children: [
                    AppBar(
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(top:40.0),
                          child: PopupMenuButton(
                            icon: Icon(FeatherIcons.moreHorizontal,
                                color: Colors.white),
                            onSelected: (value) {
                              var datas = Provider.of<Utils>(context, listen: false);
                              var location = Provider.of<LocationService>(context, listen: false);
                              datas.makeOpenUrl(
                                  'https://www.google.com/maps?saddr=${location.locationLatitude},${location.locationLongitude}&daddr= ${userData.latitude}, ${userData.longitude}');
                            },
                            elevation: 0.1,
                            padding: EdgeInsets.all(0),
                            color: Color(0xFFF6F6F6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                height: 30,
                                value: "get direction",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Get direction",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            height: 1.4,
                                            fontWeight: FontWeight.w600)),
                                    Icon(
                                      FeatherIcons.map,
                                      color: Color(0xFF9B049B),
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      backgroundColor: Color(0xFF9B049B),
                      leading: Text(''),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:30.0),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  children: [


                    Container(
                      color: Color(0xFFF0F0F0),
                      child: Row(
                        children: [
                          for (dynamic item in data.productImages)
                            Hero(
                              tag:  'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context,
                                          animation,
                                          secondaryAnimation) {
                                        return PhotoView(
                                          'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                                          'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                                        );
                                      },
                                      transitionsBuilder:
                                          (context,
                                          animation,
                                          secondaryAnimation,
                                          child) {
                                        return FadeTransition(
                                          opacity:
                                          animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 200,
                                          child: Image.network(
                                            'https://uploads.fixme.ng/thumbnails/${item['imageFileName']}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "${data.product_name}".capitalizeFirstOfEach,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Align(
                        alignment:Alignment.bottomLeft,
                        child: Text(
                          "Description:",
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "${data.description}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Divider(),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'NGN ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${data.price}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Divider(),









                    Container(
                      padding: EdgeInsets.only( left:  80, right: 80),
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        onPressed: () {
                          var network = Provider.of<WebServices>(context, listen: false);
                          var datas = Provider.of<Utils>(context, listen: false);
                          FirebaseApi.addUserChat(
                            token2: datas.fcmToken,
                            token:userData.fcmToken,
                            recieveruserId2: network.userId,
                            recieveruserId:  userData.id,
                            serviceId: userData.serviceId,
                            serviceId2: network.serviceId,
                            urlAvatar2:
                            'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                            name2: network.firstName,
                            idArtisan: network.mobileDeviceToken,
                            artisanMobile: network.phoneNum,
                            userMobile: userData.userMobile,
                            idUser: userData.idUser,
                            urlAvatar:
                            'https://uploads.fixme.ng/thumbnails/${userData.urlAvatar}',
                            name: userData.name,
                          );

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) {
                                return ChatPage(user: userData, productData: data, productSend: 'send', instantChat: 'market',);
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 200, minHeight: 36.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Get this Product",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.only(left: 18, right: 18, top: 18),
                      child: Row(
                        children: [
                          Stack(children: <Widget>[
                            CircleAvatar(
                              child: Text(''),
                              radius: 50,
                              backgroundImage: NetworkImage(
                                userData == 'no_picture_upload' ||userData == null
                                    ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                    : 'https://uploads.fixme.ng/thumbnails/${userData.urlAvatar}',
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white,
                            ),

                          ]),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        '${userData.name} ${userData.userLastName}'
                                            .capitalizeFirstOfEach,
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${userData.serviceArea}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.5,
                                        color: Color(0xFFBCBCBC)),
                                  ),
                                ),
                                SizedBox(height: 2),


                                Row(
                                  children: [
                                    Text(
                                      '${double.parse(userData.userRating.toString())}',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFFC5302),
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '(${userData.reviews} reviews)',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // StarRating(
                                    //   rating: double.parse(
                                    //       widget.userData.userRating.toString()),
                                    // ),
                                  ],
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 120, right :120, top:30,bottom: 30),
                      height: 35,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFFE9E9E9), width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context,
                                  animation,
                                  secondaryAnimation) {
                                return ArtisanPageNew(
                                    userData);
                              },
                              transitionsBuilder: (context,
                                  animation,
                                  secondaryAnimation,
                                  child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        // full_number
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 100, minHeight: 35.0),
                            alignment: Alignment.center,
                            child: Text(
                              "View Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          );
        });
  }
}


