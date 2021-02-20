import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/utils.dart';

class PopularServices extends StatefulWidget {
  PopularServices(
      {Key key,
      this.serviceName = 'services',
      this.serviceId,
      this.longitude,
      this.latitude})
      : super(key: key);
  final String serviceName;
  final String serviceId;
  final double longitude;
  final double latitude;

  @override
  _PopularServicesState createState() => _PopularServicesState();
}

//6.4889151, 3.0683489
class _PopularServicesState extends State<PopularServices> {
  String getDistance({double artisanLongitude, double artisanLatitude}) {
    double distanceInMeters = Geolocator.distanceBetween(
        widget.latitude, widget.longitude, artisanLatitude, artisanLongitude);
    var kilometers = distanceInMeters / 1000;
    String distance;
    if (kilometers.truncate() != 0) {
      distance = '${kilometers.truncate()} km';
    } else {
      distance = '${distanceInMeters.truncate()} m';
    }
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Nearby ${widget.serviceName}s',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: Color(0xFF9B049B),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
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
                      hintText: 'Search ${widget.serviceName}s',
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
                // latitude: '6.295660',
                //   longitude: '5.642040',
                future: network.getServiceProviderByServiceID(
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    serviceID: widget.serviceId),
                builder: (context, snapshot) {
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
                              Text('No nearby ${widget.serviceName}s',
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
                                  artisanLatitude: snapshot.data[index]
                                      ['latitude'],
                                  artisanLongitude: snapshot.data[index]
                                      ['longitude']);
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
                                          return ArtisanPage(
                                              snapshot.data[index]);
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
                                  leading: CircleAvatar(
                                    child: Text(''),
                                    radius: 35,
                                    backgroundImage: NetworkImage(
                                      snapshot.data[index][
                                                      'profile_pic_file_name'] ==
                                                  'no_picture_upload' ||
                                              snapshot.data[index][
                                                      'profile_pic_file_name'] ==
                                                  null
                                          ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                          : 'https://uploads.fixme.ng/originals/${snapshot.data[index]['profile_pic_file_name']}',
                                    ),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white,
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${snapshot.data[index]['user_first_name']} ${snapshot.data[index]['user_last_name']}'
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
                                              '${snapshot.data[index]['service_area']}'
                                                  .capitalizeFirstOfEach,
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: StarRating(
                                            rating: double.parse(snapshot
                                                .data[index]['user_rating']
                                                .toString())),
                                      )
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
