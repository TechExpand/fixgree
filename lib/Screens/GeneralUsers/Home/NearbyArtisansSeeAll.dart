import 'dart:convert';

import 'package:fixme/Model/UserSearch.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:http/http.dart' as http;
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/utils.dart';

class NearbyArtisansSeeAll extends StatefulWidget {
  NearbyArtisansSeeAll({Key key, @required this.longitude, this.latitude})
      : super(key: key);

  final double longitude;
  final double latitude;
  @override
  _NearbyArtisansSeeAllState createState() => _NearbyArtisansSeeAllState();
}

class _NearbyArtisansSeeAllState extends State<NearbyArtisansSeeAll> {
  ScrollController scrollController = ScrollController();
  String getDistance({String rawDistance}) {
    String distance;
    distance = '$rawDistance' + 'km';
    return distance;
  }




  var filteredItems = [];
  TextEditingController searchController = TextEditingController();
List data;
String nodata;

  @override
  void initState() {
    var network = Provider.of<WebServices>(context, listen: false);
    var location = Provider.of<LocationService>(context, listen: false);
    network.nearbyArtisans(
        latitude: location.locationLatitude,
        longitude: location.locationLongitude,
        context:context
    ).then((value) {
      setState(() {
        data = value;
      });

    });




    scrollController.addListener(()async{
      bool isLoading = false;
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels){
        var location = Provider.of<LocationService>(context,listen: false);
        var network = Provider.of<WebServices>(context, listen: false);
        var response = await http
            .post(Uri.parse('https://manager.fixme.ng/load-more-service-providers'), body: {
          'user_id': network.userId.toString(),
          'latitude':  location.locationLatitude.toString(),
          'longitude' :location.locationLongitude.toString(),
          // 'latitude':  '5.001190',
          // 'longitude' :'8.334840',
          'highestId':  data.length.toString(),

//      'longitude': longitude.toString(),
//      'latitude': latitude.toString(),
        }, headers: {
          "Content-type": "application/x-www-form-urlencoded",
          'Authorization': 'Bearer ${network.bearer}',
        });
        print(response.statusCode);
        if(response.statusCode == 500){
          print("You are not connected to internet");
        }else{
          var body = json.decode(response.body);
          print(body.toString());
          List result = body['sortedUsers'];
          List<UserSearch> nearebyList = result.map((data) {
            return UserSearch.fromJson(data);
          }).toList();
          if (body['reqRes'] == 'true') {
            setState(() {
              data.addAll(nearebyList);
            });
            // providers.setUseritems(data,nearebyList);
            return nearebyList;
          }else if(body['message'] == 'No Additional Data'){
            setState(() {
              nodata = 'No Additional Data';
            });

          }
          else if (body['reqRes'] == 'false') {
            print(body['message']);
          }
        }
        // setState(() {
        //   print('ss');
        // });

        // nearbyArtisans(longitude:1, latitude:1, highestId:userItems[userItems.length]);
//      if (!isLoading) {
//        isLoading = !isLoading;
//
//
//        // Perform event when user reach at the end of list (e.g. do Api call)
//      }
      }
    });


    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    DataProvider providers = Provider.of<DataProvider>(context, listen: false);



    var network = Provider.of<WebServices>(context, listen: false);
    var location = Provider.of<LocationService>(context, listen: false);
    var provider = Provider.of<DataProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Nearby artisans',
            style: GoogleFonts.poppins(
                color: Color(0xFF9B049B),
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
        ),
        elevation: 0,
      ),
      body: Column(children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12),
          margin:
              const EdgeInsets.only(bottom: 15, left: 12, right: 12, top: 15),
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border.all(color: Color(0xFFF1F1FD)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFF1F1FD).withOpacity(0.5),
                    blurRadius: 15.0,
                    offset: Offset(0.3, 1.0))
              ],
              borderRadius: BorderRadius.all(Radius.circular(35))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  FeatherIcons.search,
                  color: Color(0xFF555555),
                  size: 20,
                ),
              ),
              Expanded(
                child: InkWell(
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
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF270F33),
                        fontWeight: FontWeight.w600),
                    controller: searchController,
                    enabled: false,

                    // onChanged: (value) {
                    //   filterSearchResults(value);
                    // },
                    decoration: InputDecoration.collapsed(
                      hintText: 'What are you looking for?',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      focusColor: Color(0xFF2B1137),
                      fillColor: Color(0xFF2B1137),
                      hoverColor: Color(0xFF2B1137),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
              child: Builder(
                  builder: (context) {
                    Widget mainWidget;

                      if (data == null) {
                        mainWidget = Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Loading',
                                  style: TextStyle(
                                      // letterSpacing: 4,
                                      color: Color(0xFF333333),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      } else {
                        if (data.isEmpty) {
                          mainWidget = Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('No nearby Artisan',
                                    style: TextStyle(
                                        // letterSpacing: 4,
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        } else {
                          provider.userItems = List.generate(data.length,
                              (index) => data[index]);
                          mainWidget = filteredItems.length != 0 ||
                                  searchController.text.isNotEmpty
                              ? ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  itemCount: filteredItems.length,
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  itemBuilder: (context, index) {
                                    String distance = getDistance(
                                        rawDistance:
                                            '${filteredItems[index].distance}');
                                    return Container(
                                      alignment: Alignment.center,
                                      height: 90,
                                      margin: const EdgeInsets.only(
                                          bottom: 5, top: 5),
                                      child: ListTile(
                                        onTap: () {
                                          network.postViewed(filteredItems[index].id);
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return ArtisanPageNew(
                                                    filteredItems[index]);
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
                                        leading: CircleAvatar(
                                          child: Text(''),
                                          radius: 35,
                                          backgroundImage: NetworkImage(
                                            filteredItems[index].urlAvatar ==
                                                        'no_picture_upload' ||
                                                    filteredItems[index]
                                                            .urlAvatar ==
                                                        null
                                                ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                : 'https://uploads.fixme.ng/originals/${filteredItems[index].urlAvatar}',
                                          ),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.white,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '${filteredItems[index].name} ${filteredItems[index].userLastName}'
                                                .capitalizeFirstOfEach,
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        subtitle: Column(
                                          children: [
                                            Wrap(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${filteredItems[index].serviceArea}'
                                                        .capitalizeFirstOfEach,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF333333),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: StarRating(
                                                  rating: double.parse(
                                                      filteredItems[index]
                                                          .userRating
                                                          .toString())),
                                            )
                                          ],
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Color(0xFFA40C85),
                                              size: 23,
                                            ),
                                            Text(
                                              '$distance',
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              :
                    ListView.separated(
                            controller: scrollController,
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                    itemCount: data.length,
                                    padding:
                                        const EdgeInsets.only(left: 5, right: 5),
                                    itemBuilder: (context, index) {
                              print(data.length.toString()+nodata.toString());
                                      String distance = getDistance(
                                          rawDistance:
                                              '${data[index].distance}');
                                      return index+1 == data.length && nodata != 'No Additional Data'?Container(
                                        margin:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/2.29),
                                        padding: const EdgeInsets.only(top:15,bottom: 15),
                                        child: Theme(
                                            data: Theme.of(context).copyWith(
                                                accentColor: Color(0xFF9B049B)),
                                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                strokeWidth: 2,
                                                backgroundColor: Colors.white,
                                            )),
                                      ):Container(
                                        alignment: Alignment.center,
                                        height: 90,
                                        margin: const EdgeInsets.only(
                                            bottom: 5, top: 5),
                                        child: ListTile(
                                          onTap: () {
                                            network.postViewed(data[index].id);
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation,
                                                    secondaryAnimation) {
                                                  return ArtisanPageNew(
                                                      data[index]);
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
                                          leading: CircleAvatar(
                                            child: Text(''),
                                            radius: 35,
                                            backgroundImage: NetworkImage(
                                              data[index].urlAvatar ==
                                                          'no_picture_upload' ||
                                                  data[index]
                                                              .urlAvatar ==
                                                          null
                                                  ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                  : 'https://uploads.fixme.ng/originals/${data[index].urlAvatar}',
                                            ),
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.white,
                                          ),
                                          title: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              '${data[index].name} ${data[index].userLastName}'
                                                  .capitalizeFirstOfEach,
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Wrap(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${data[index].serviceArea}'
                                                          .capitalizeFirstOfEach,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF333333),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(top: 8),
                                                child: StarRating(
                                                    rating: double.parse(
                                                        data[index]
                                                            .userRating
                                                            .toString())),
                                              )
                                            ],
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Color(0xFFA40C85),
                                                size: 23,
                                              ),
                                              Text(
                                                '$distance',
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });}

                      }
                    // } else {
                    //   mainWidget = Center(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Theme(
                    //             data: Theme.of(context)
                    //                 .copyWith(accentColor: Color(0xFF9B049B)),
//                     //             child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//      valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
// )),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         Text('Loading',
                    //             style: TextStyle(
                    //                 // letterSpacing: 4,
                    //                 color: Color(0xFF333333),
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.w600)),
                    //       ],
                    //     ),
                    //   );
                    // }
                    return mainWidget;
                  })),
        ),
      ]),
    );
  }

  void filterSearchResults(String query) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    filteredItems.clear();
    if (query.isEmpty) {
      setState(() {});

      return;
    } else {
      data.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          filteredItems.add(item);
        }
      });
      setState(() {});
    }
  }
}

