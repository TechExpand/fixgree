import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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
  final String longitude;
  final String latitude;

  @override
  _PopularServicesState createState() => _PopularServicesState();
}

class _PopularServicesState extends State<PopularServices> {
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, bottom: 15),
            child: Row(
              children: [
                Text(
                  'Nearby ${widget.serviceName}s',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: Color(0xFF270F33),
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
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                height: 75,
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
                                      snapshot.data[index].urlAvatar ==
                                                  'no_picture_upload' ||
                                              snapshot.data[index].urlAvatar ==
                                                  null
                                          ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                          : 'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                    ),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white,
                                  ),
                                  title: Text(
                                    '${snapshot.data[index].name} ${snapshot.data[index].userLastName}',
                                    // .capitalizeFirstOfEach,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    '${snapshot.data[index].serviceArea}',
                                    // .capitalizeFirstOfEach,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 23,
                                      ),
                                      Text(
                                        '${snapshot.data[index].userRating}',
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
