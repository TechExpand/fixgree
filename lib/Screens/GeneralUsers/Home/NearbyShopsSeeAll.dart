import 'dart:convert';

import 'package:fixme/Model/UserSearch.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/utils.dart';

class NearbyShopsSeeAll extends StatefulWidget {
  final double longitude;
  final double latitude;

  const NearbyShopsSeeAll({Key key, this.longitude, this.latitude})
      : super(key: key);
  @override
  _NearbyShopsSeeAllState createState() => _NearbyShopsSeeAllState();
}

class _NearbyShopsSeeAllState extends State<NearbyShopsSeeAll> {
  String getDistance({String rawDistance}) {
    String distance;
    distance = '$rawDistance' + 'km';
    return distance;
  }
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();


  var filteredItems = [];




//  Future<dynamic> nearbyShops({longitude, latitude, highestId}) async {
//    var network = Provider.of<WebServices>(context, listen: false);
//    print(network.userId.toString());
//    var response = await http
//        .post(Uri.parse('https://manager.fixme.ng/load-more-near-shop'), body: {
//      'user_id': network.userId.toString(),
//      'latitude':  '5.001190',
//      'longitude' :'8.334840',
//      'highestId':  highestId.toString(),
//
////      'longitude': longitude.toString(),
////      'latitude': latitude.toString(),
//    }, headers: {
//      "Content-type": "application/x-www-form-urlencoded",
//      'Authorization': 'Bearer ${network.bearer}',
//    });
//
//    if(response.statusCode == 500){
//      print("You are not connected to internet");
//    }else{
//      var body = json.decode(response.body);
//      print(body.toString());
//      List result = body['sortedUsers'];
//      List<UserSearch> nearebyList = result.map((data) {
//        return UserSearch.fromJson(data);
//      }).toList();
//      if (body['reqRes'] == 'true') {
//        provider.userItems1 = provider.userItems1+nearebyList;
//        print(provider.userItems1.length.toString()+ provider.userItems1[provider.userItems1.length-1].id.toString() +'lllll');
//        return nearebyList;
//      } else if (body['reqRes'] == 'false') {
//        print(body['message']);
//      }
//    }
//  }



  @override
  Widget build(BuildContext context) {
    DataProvider providers = Provider.of<DataProvider>(context, listen: false);
    scrollController.addListener(()async{
      bool isLoading = false;
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels){
        var location = Provider.of<LocationService>(context);
        var network = Provider.of<WebServices>(context, listen: false);
        var response = await http
            .post(Uri.parse('https://manager.fixme.ng/load-more-near-shop'), body: {
          'user_id': network.userId.toString(),
          'latitude':  location.locationLatitude.toString(),
          'longitude' :location.locationLongitude.toString(),
          'highestId':  providers.userItems.length.toString(),

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
            providers.setUseritems1(providers.userItems,nearebyList);
            print(providers.userItems.length.toString() +'lllll');
            return nearebyList;
          } else if (body['reqRes'] == 'false') {
            print(body['message']);
          }
        }

        // nearbyArtisans(longitude:1, latitude:1, highestId:userItems[userItems.length]);
//      if (!isLoading) {
//        isLoading = !isLoading;
//
//
//        // Perform event when user reach at the end of list (e.g. do Api call)
//      }
      }
    });

    var provider = Provider.of<DataProvider>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    var location = Provider.of<LocationService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Nearby shops',
            style: GoogleFonts.openSans(
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
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF270F33),
                      fontWeight: FontWeight.w600),
                  controller: searchController,
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search shops',
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    focusColor: Color(0xFF2B1137),
                    fillColor: Color(0xFF2B1137),
                    hoverColor: Color(0xFF2B1137),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
              child: FutureBuilder(
                  future: network.nearbyShop(
                      latitude: location.locationLatitude,
                      longitude: location.locationLongitude),
                  builder: (context, AsyncSnapshot snapshot) {
                    Widget mainWidget;
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null) {
                        mainWidget = Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator()),
                              SizedBox(
                                height: 10,
                              ),
                              Text('No Network',
                                  style: TextStyle(
                                      // letterSpacing: 4,
                                      color: Color(0xFF333333),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      } else {
                        if (snapshot.data.isEmpty) {
                          mainWidget = Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('No nearby shops',
                                    style: TextStyle(
                                        // letterSpacing: 4,
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        } else {
                          provider.userItems1 = List.generate(snapshot.data.length,
                              (index) => snapshot.data[index]);
                          mainWidget = filteredItems.length != 0 ||
                                  searchController.text.isNotEmpty
                              ? ListView.separated(
                            controller: scrollController,
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
                                              Icons.location_on_outlined,
                                              color: Colors.amber,
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
                              : Consumer<DataProvider>(
                              builder: (context, provider, _) {
                                return ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  itemCount: provider.userItems1.length,
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  itemBuilder: (context, index) {
                                    String distance = getDistance(
                                        rawDistance:
                                            '${provider.userItems1[index].distance}');
                                    return index+1 == provider.userItems1.length?Container(
                                      margin:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/2.29),
                                      padding: const EdgeInsets.only(top:15,bottom: 15),
                                      child: Theme(
                                          data: Theme.of(context).copyWith(
                                              accentColor: Color(0xFF9B049B)),
                                          child: CircularProgressIndicator(
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
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return ArtisanPageNew(
                                                    provider.userItems1[index]);
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
                                            provider.userItems1[index].urlAvatar ==
                                                        'no_picture_upload' ||
                                                    provider.userItems1[index]
                                                            .urlAvatar ==
                                                        null
                                                ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                : 'https://uploads.fixme.ng/originals/${provider.userItems1[index].urlAvatar}',
                                          ),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.white,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '${provider.userItems1[index].name} ${provider.userItems1[index].userLastName}'
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
                                                    '${provider.userItems1[index].serviceArea}'
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
                                                      provider.userItems1[index]
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
                                              Icons.location_on_outlined,
                                              color: Colors.amber,
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
                          );}
                      }
                    } else {
                      mainWidget = Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: Color(0xFF9B049B)),
                                child: CircularProgressIndicator()),
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
                    }
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
      provider.userItems1.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          filteredItems.add(item);
        }
      });
      setState(() {});
    }
  }
}
