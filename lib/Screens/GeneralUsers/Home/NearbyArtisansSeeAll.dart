import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
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
  String getDistance({String rawDistance}) {
    String distance;
    print('The distance $rawDistance');
    if (rawDistance.length > 3) {
      distance = '$rawDistance' + 'km';
    } else {
      distance = '$rawDistance' + 'm';
    }
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var location = Provider.of<LocationService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Nearby artisans',
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
                  // controller: searchController,
                  onChanged: (value) {
                    // print('Tapped!');
                    // filterSearchResults(value);
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search artisans',
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
                  future: network.nearbyArtisans(
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
                          mainWidget = ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemCount: snapshot.data.length,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              itemBuilder: (context, index) {
                                String distance = getDistance(
                                    rawDistance:
                                        '${snapshot.data[index].distance}');

                                return Container(
                                  alignment: Alignment.center,
                                  height: 90,
                                  margin:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return ArtisanPageNew(
                                                snapshot.data[index]);
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
                                        snapshot.data[index].urlAvatar ==
                                                    'no_picture_upload' ||
                                                snapshot.data[index]
                                                        .urlAvatar ==
                                                    null
                                            ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                            : 'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white,
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        '${snapshot.data[index].name} ${snapshot.data[index].userLastName}'
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
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${snapshot.data[index].serviceArea}'
                                                    .capitalizeFirstOfEach,
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
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
                                              rating: double.parse(snapshot
                                                  .data[index].userRating
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
}
