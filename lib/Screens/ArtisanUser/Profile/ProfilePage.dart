import 'dart:io';

import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Model/service.dart';
import 'package:fixme/Widgets/ExpandedText.dart';
import 'package:fixme/Widgets/Rating.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var first;

  @override
  void initState() {
    super.initState();
    address();
  }

  address() async {
    var location = Provider.of<LocationService>(context);
    final coordinates = new Coordinates(
        location.location_longitude, location.location_latitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      first = addresses.first;
    });
  }

  List<Services> result = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context);

    var network = Provider.of<WebServices>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomePage();
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
      child: Material(
        child: FutureBuilder(
            future: network.getUserInfo(network.user_id),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .02),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Row(
                              children: [
                                Stack(children: <Widget>[
                                  CircleAvatar(
                                    child: Text(''),
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      network.profile_pic_file_name ==
                                                  'no_picture_upload' ||
                                              network.profile_pic_file_name ==
                                                  null
                                          ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                          : 'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
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
                                          color: Color(0xFFDB5B04),
                                          shape: BoxShape.circle),
                                      child: Text(''),
                                    ),
                                  ),
                                ]),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(''),
                                    Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom: 6,
                                        ),
                                        child: Text(
                                          '${snapshot.data['firstName']} ${snapshot.data['lastName']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                      ),
                                      SizedBox(width: 80),
                                      InkWell(
                                          onTap: () {
                                            _editName('Edit Full Name');
                                          },
                                          child: Icon(Icons.edit,
                                              color: Color(0xFF747474)))
                                    ]),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.8, bottom: 6),
                                      child: Row(
                                        children: [
                                          Icon(Icons.pin_drop,
                                              color: Color(0xFF9B049B)),
                                          Container(
                                              width: 150,
                                              child: Text(
                                                '${first == null ? 'Location' : first.addressLine}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ],
                                      ),
                                    ),
                                    snapshot.data['identificationStatus'] ==
                                            'un-verified'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, bottom: 6),
                                            child: Text('Unverified',
                                                style: TextStyle(
                                                  color: Color(0xFFFF0000)
                                                      .withOpacity(0.75),
                                                )),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, bottom: 6),
                                            child: Text('Verified',
                                                style: TextStyle(
                                                  color: Color(0xFF27AE60)
                                                      .withOpacity(0.9),
                                                )),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Wrap(children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: InkWell(
                                  onTap: () {
                                    _editService('Edit Service');
                                  },
                                  child: Icon(Icons.edit,
                                      color: Color(0xFF747474))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 18.0, left: 18, right: 18),
                              child: Text(
                                '${snapshot.data['serviceArea']}'.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19.5),
                              ),
                            ),
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 13, left: 18, right: 18),
                            child: Row(
                              children: [
                                Text('Wholesales Channel'),
                                SizedBox(
                                  width: 10,
                                ),
                                StarRating(
                                  rating: double.parse(
                                      snapshot.data['user_rating'].toString()),

                                  /// onRatingChanged: (rating) => setState(() => this.rating = rating),
                                ),
                              ],
                            ),
                          ),
                          Wrap(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0, bottom: 5, left: 18, right: 18),
                              child: Text(
                                'About',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 19),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  _editAbout('Edit About');
                                },
                                child:
                                    Icon(Icons.edit, color: Color(0xFF747474))),
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, left: 18, bottom: 15, right: 18),
                            child: ExpandableText(
                              '${snapshot.data['bio']}',
                            ),
                          ),
                          Material(
                            elevation: 1.8,
                            child: Container(
                              width: double.infinity,
                              color: Color(0xFF666666).withOpacity(0.5),
                              height: 1,
                            ),
                          ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 13.0, bottom: 5, left: 18, right: 18),
                              child: Text(
                                'Business Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 19),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 15, left: 18, right: 18),
                            child: Text(
                              '${snapshot.data['businessAddress'].toString().isEmpty ? snapshot.data['address'] : snapshot.data['businessAddress']}',
                              style: TextStyle(height: 1.5),
                            ),
                          ),
                          Material(
                            elevation: 1.8,
                            child: Container(
                              width: double.infinity,
                              color: Color(0xFF666666).withOpacity(0.5),
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 13.0, bottom: 5, left: 18, right: 18),
                            child: Text(
                              'SubServices',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 19),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 15, left: 18, right: 18),
                            child: Text(
                              '${snapshot.data['subServices'][0]['subservice']}',
                              style: TextStyle(height: 1.5),
                            ),
                          ),
                          Material(
                            elevation: 1.8,
                            child: Container(
                              width: double.infinity,
                              color: Color(0xFF666666).withOpacity(0.5),
                              height: 1,
                            ),
                          ),
                          snapshot.data['role'] == 'artisan'
                              ?
                          FutureBuilder(
                                  future: network.getServiceImage(
                                      network.user_id, network.user_id),
                                  builder: (context, snapshot) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13.0,
                                              bottom: 7,
                                              left: 18,
                                              right: 18),
                                          child: Row(children: [
                                            Text(
                                              'Catalogues(${snapshot.data == null ? 0 : snapshot.data.length})',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 19),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  _addService('Add Service Picture');
                                                },
                                                child: Icon(Icons.add,
                                                    color: Color(0xFF747474))),
                                          ]),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 30.0,
                                                left: 8,
                                                right: 8),
                                            child: GridView.builder(
                                              reverse: true,
                                              shrinkWrap: true,
                                              physics: ScrollPhysics(),
                                              itemCount: snapshot.data == null
                                                  ? 0
                                                  : snapshot.data.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) {
                                                          return PhotoView(
                                                            'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                            snapshot.data[index]
                                                                [
                                                                'imageFileName'],
                                                          );
                                                        },
                                                        transitionsBuilder:
                                                            (context,
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
                                                  child: Hero(
                                                    tag: snapshot.data[index]
                                                        ['imageFileName'],
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                          width: 200,
                                                          child: Image.network(
                                                            'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                      ],
                                    );
                                  })
                              : FutureBuilder(
                                  future: network.getProductImage(
                                      network.user_id, network.user_id),
                                  builder: (context, snapshots) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 13.0,
                                                bottom: 7,
                                                left: 18,
                                                right: 18),
                                            child: Text(
                                              'Catalogues(${snapshots.data == null ? 0 : snapshots.data.length})',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 19),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                _addProduct('Add Product');
                                              },
                                              child: Icon(Icons.add,
                                                  color: Color(0xFF747474))),
                                        ]),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 30.0,
                                                left: 8,
                                                right: 8),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              reverse: true,
                                              physics: ScrollPhysics(),
                                              itemCount: snapshots.data == null
                                                  ? 0
                                                  : snapshots.data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    child: ListTile(
                                                      title: Text(
                                                          "${snapshots.data[index]['product_name']}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      subtitle: Text(
                                                          "${snapshots.data[index]['price']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      trailing: Text(
                                                          '${snapshots.data[index]['status']}'),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                      ],
                                    );
                                  }),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF9B049B))));
            }),
      ),
    );
  }

  void _editAbout(value) {
    final _controller = TextEditingController();
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 160.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Text(
                        "$value",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 33,
                              child: TextField(
                                controller: _controller,
                                // onChanged: (String value) =>
                                //     setState(() => _controllerLenght = value.length),
                                // inputFormatters: [
                                //   LengthLimitingTextInputFormatter(25),
                                // ],
                                decoration: InputDecoration(
                                  hintText: 'Bio',
                                  focusColor: Colors.black,
                                  border: InputBorder.none,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA40C85)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA40C85)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.sentiment_satisfied,
                              color: Color(0xFFA40C85),
                              size: 25,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            network.updateBio(_controller.text).then((value) {
                              setState(() {});
                            });
                          },
                        )
                      ])
                    ],
                  )));
        });
  }

  void _editName(value) {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        //isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 200.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: ListView(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$value",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 33,
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'First Name',
                                focusColor: Colors.black,
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA40C85)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA40C85)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.sentiment_satisfied,
                              color: Color(0xFFA40C85),
                              size: 25,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 33,
                              child: TextField(
                                controller: _controller2,
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  focusColor: Colors.black,
                                  border: InputBorder.none,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA40C85)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA40C85)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.sentiment_satisfied,
                              color: Color(0xFFA40C85),
                              size: 25,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            network
                                .updateFullName(
                                    _controller.text, _controller2.text)
                                .then((value) {
                              setState(() {});
                            });
                          },
                        )
                      ])
                    ],
                  )));
        });
  }

  void _editService(value) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    final _controller2 = TextEditingController();
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        //isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 160.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Text(
                        "$value",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          result = postRequestProvider.allservicesList;
                          DialogPage(context);
                        },
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          enabled: false,
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black38),
                            labelText: postRequestProvider.selecteService ==
                                    null
                                ? 'Select Service'
                                : postRequestProvider.selecteService.service,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black38),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            network
                                .updateService(
                                    postRequestProvider.selecteService.sn)
                                .then((value) {
                              setState(() {});
                            });
                          },
                        )
                      ])
                    ],
                  )));
        });
  }

  void _addProduct(value) {
    DataProvider datas = Provider.of<DataProvider>(context,listen: false);
    Utils data = Provider.of<Utils>(context,listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        //isScrollControlled: true,
        builder: (builder) {
          return new StatefulBuilder(
            builder:(context, setStat){
              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                      height: 1000.0,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      color: Colors.transparent,
                      child: ListView(
                        children: [
                          Text(
                            "$value",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            width: MediaQuery.of(context).size.width / 0.2,
                            height: 55,
                            child: TextFormField(
                              onChanged: (value) {
                                datas.setProductName(value);
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black38),
                                labelText: 'Product Name',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            width: MediaQuery.of(context).size.width / 0.2,
                            height: 55,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                datas.setProductPrice(value);
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black38),
                                labelText: 'Product Price',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            width: MediaQuery.of(context).size.width / 0.2,
                            height: 55,
                            child: TextFormField(
                              onChanged: (value) {
                                datas.setProductBio(value);
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black38),
                                labelText: 'Product Description',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF9B049B), width: 0.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: 100, // card height
                              child: data.selected_image2 == null
                                  ? Text('No Image Selected')
                                  : Container(
                                width: 100,
                                child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    child: Image.file(
                                      File(
                                        data.selected_image2.path,
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(26)),
                                child: FlatButton(
                                  disabledColor: Color(0xFF9B049B),
                                  onPressed: () {
                                    data.selectimage2(source: ImageSource.gallery).then((value){
                                      setStat((){});
                                    });
                                  },
                                  color: Color(0xFF9B049B),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                          minHeight: 45.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Select Catalog Photo",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30,
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            InkWell(
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xFFA40C85)),
                              ),
                              onTap: () => Navigator.pop(context),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xFFA40C85)),
                              ),
                              onTap:(){
                                Navigator.pop(context);
                                network.addProductCatalog(
                                  scaffoldKey: scaffoldKey,
                                  context: context,
                                  bio: datas.product_bio,
                                  product_name: datas.product_name,
                                  price: datas.product_price,
                                  path: data.selected_image2.path,
                                ).then((value){
                                  setState((){
                                  });
                                });
                              },
                            )
                          ])
                        ],
                      )));
            }
          );
        });
  }




  void _addService(value) {
    DataProvider datas = Provider.of<DataProvider>(context,listen: false);
    Utils data = Provider.of<Utils>(context,listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new StatefulBuilder(
              builder:(context, setStat){
                return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                        height: 1000.0,
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        color: Colors.transparent,
                        child: ListView(
                          children: [
                            Text(
                              "$value",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            SizedBox(
                                child:  Center(
                                  child: SizedBox(
                                    height: 200, // card height
                                    child: data.selected_image2 ==null?Text(''):Container(
                                      width: 200,
                                      child:Card(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          child: Image.file(File(data.selected_image2.path,), fit: BoxFit.cover,)

                                      ),
                                    ),
                                  ),
                                ),
                                height: MediaQuery.of(context).size.height/3),

                            Material(
                              elevation: 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: Container(

                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(26)),
                                  child: FlatButton(
                                    disabledColor: Colors.white,
                                    onPressed: () {
                                      data.selectimage2(source: ImageSource.gallery);


                                    },
                                    color:  Colors.white,
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
                                          "Select Catalog Photo",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              InkWell(
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color(0xFFA40C85)),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                child: Text(
                                  "SAVE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color(0xFFA40C85)),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  network.addSerPic(
                                    scaffoldKey: scaffoldKey,
                                    path: data.selected_image2.path,
                                    context: context,
                                    uploadType: 'servicePicture',
                                  ).then((value){
                                    setState((){

                                    });
                                  });

                                },
                              )
                            ])
                          ],
                        )));
              }
          );
        });
  }




  void _editAddress(value) {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        //isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 160.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: ListView(
                    children: [
                      Text(
                        "$value",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 33,
                              child: TextField(
                                controller: _controller2,
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  focusColor: Colors.black,
                                  border: InputBorder.none,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA40C85)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFA40C85)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.sentiment_satisfied,
                              color: Color(0xFFA40C85),
                              size: 25,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () {
                            network.updateFullName(
                                _controller.text, _controller2.text);
                          },
                        )
                      ])
                    ],
                  )));
        });
  }

  Widget DialogPage(ctx) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStates) {
          return AlertDialog(
            title: TextFormField(
              onChanged: (value) {
                setStates(() {
                  searchServices(value);
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Search Services',
                disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(new Radius.circular(50.0)),
              ),
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 500,
                      child: ListView.builder(
                        itemCount: result == null ? 0 : result.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              postRequestProvider
                                  .changeSelectedService(result[index]);
                            },
                            child: ListTile(
                              title: Text('${result[index].service}'),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).then((v) {
      setState(() {});
    });
  }

  void searchServices(userInputValue) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    result = postRequestProvider.allservicesList
        .where((service) => service.service
            .toLowerCase()
            .contains(userInputValue.toLowerCase()))
        .toList();
  }
}
