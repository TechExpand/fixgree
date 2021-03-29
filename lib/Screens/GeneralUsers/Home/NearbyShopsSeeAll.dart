import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
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
    if (rawDistance.length > 3) {
      distance = '$rawDistance' + 'km';
    } else {
      distance = '$rawDistance' + 'm';
    }
    return distance;
  }

  TextEditingController searchController = TextEditingController();

  var userItems = [];
  var filteredItems = [];

  @override
  Widget build(BuildContext context) {
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
                          userItems = List.generate(snapshot.data.length,
                              (index) => snapshot.data[index]);
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
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  itemCount: userItems.length,
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  itemBuilder: (context, index) {
                                    String distance = getDistance(
                                        rawDistance:
                                            '${userItems[index].distance}');
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
                                                    userItems[index]);
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
                                            userItems[index].urlAvatar ==
                                                        'no_picture_upload' ||
                                                    userItems[index]
                                                            .urlAvatar ==
                                                        null
                                                ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                : 'https://uploads.fixme.ng/originals/${userItems[index].urlAvatar}',
                                          ),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.white,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '${userItems[index].name} ${userItems[index].userLastName}'
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
                                                    '${userItems[index].serviceArea}'
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
                                                      userItems[index]
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
                                  });
                        }
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
    filteredItems.clear();
    if (query.isEmpty) {
      setState(() {});

      return;
    } else {
      userItems.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          filteredItems.add(item);
        }
      });
      setState(() {});
    }
  }
}
