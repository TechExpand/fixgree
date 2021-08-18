import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Chat.dart';

class SearchChatPage extends StatefulWidget {
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChatPage> {
  var searchvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New message'),
        backgroundColor: Color(0xFF9B049B),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.clear, color: Colors.white)),
      ),
      body: Column(
        children: [
          Container(
            height: 43,
            child: Material(
              elevation: 1,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('To:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: TextFormField(
                            cursorColor: Colors.black87,
                            decoration: InputDecoration(
                              hintText: 'Type a name or multiple names',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
//                            border: InputBorder.none, counterText: ''
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchvalue = value;
                                SearchResult(searchvalue);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SearchResult(searchvalue),
        ],
      ),
    );
  }
}

class SearchResult extends StatefulWidget {
  final searchValue;

  SearchResult(this.searchValue);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchResultState();
  }
}

class SearchResultState extends State<SearchResult> {
  String getDistance({String rawDistance}) {
    String distance;
    distance = '$rawDistance' + 'km';
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var location = Provider.of<LocationService>(context);

    return FutureBuilder(
      future: network.search(
        searchquery: widget.searchValue,
        latitude: location.locationLatitude,
        longitude: location.locationLongitude,
      ),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Expanded(child: Center(child: Text('Loading...', style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)))
            : widget.searchValue == '' || widget.searchValue == null
                ? Expanded(
                    child: Center(child: Text('Search for Artisans/Services',
                      style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)))
                : !snapshot.hasData
                    ? Expanded(
                        child: Center(child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),))
                    :

        snapshot.hasData && snapshot.data.length != 0
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  String distance = getDistance(
                                      rawDistance:
                                      '${snapshot.data[index].distance}');

                                  return


                                    Container(
                                      alignment: Alignment.center,
                                      height: 90,
                                      margin: const EdgeInsets.only(
                                          bottom: 5, top: 5),
                                      child: ListTile(
                                        onTap: () {
                         var data = Provider.of<Utils>(context, listen: false);

                                      FirebaseApi.addUserChat(
                                          token2: data.fcmToken ,
                            token: snapshot.data[index].fcmToken,
                                        urlAvatar2:
                                            'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                                        name2: network.firstName,
                                        serviceId: snapshot.data[index].serviceId,
                            serviceId2: network.serviceId,
                                        recieveruserId2: network.userId,
                                         recieveruserId:  snapshot.data[index].id,
                                        idArtisan: network.mobileDeviceToken,
                                        artisanMobile: network.phoneNum,
                                        userMobile:
                                            snapshot.data[index].userMobile,
                                        idUser: snapshot.data[index].idUser,
                                        urlAvatar:
                                            'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                        name: snapshot.data[index].name,
                                      );
//                                      FirebaseApi.uploadCheckChat(
//                                        snapshot.data[index].id,
//                                      );
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return ChatPage(
                                                user: snapshot.data[index]);
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
                                          backgroundImage: NetworkImage(snapshot
                                                                  .data[index]
                                                                  .urlAvatar ==
                                                              'no_picture_upload' ||
                                                          snapshot.data[index]
                                                                  .urlAvatar ==
                                                              null
                                                      ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                      : 'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}'),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.white,
                                        ),
                                        title: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 10),
                                          child: Text(
                                            snapshot.data[index]
                                                                .userLastName
                                                                .toString() +
                                                            ' ' +
                                                            snapshot.data[index]
                                                                .name
                                                                .toString()
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
                                                    snapshot.data[index]
                                                            .serviceArea
                                                            .toString()
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
                                                      snapshot.data[index].userRating
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




                                }),
                          )
                        : snapshot.data.length == 0
                            ? Expanded(
                                child: Center(
                                    child: Text('Artisans/Service Not Found',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)))
                            : Expanded(child: Center(child: Text('')));
      },
    );
  }
}
