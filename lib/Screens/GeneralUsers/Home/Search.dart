import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fixme/Model/service.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/listen_incoming_call.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/utils.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  var searchvalue;


  GlobalKey<AutoCompleteTextFieldState<Services>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    PostRequestProvider postRequestProvider =
    Provider.of<PostRequestProvider>(context);
    var widget = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Search for a service',
            style: GoogleFonts.poppins(
                color: Color(0xFF9B049B),
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600)),
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
          Hero(
            tag: 'searchButton',
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 12),
                  margin: const EdgeInsets.only(
                      bottom: 15, left: 12, right: 12, top: 15),
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
              child:searchTextField = AutoCompleteTextField<Services>(
                textSubmitted: (e){
                  setState(() {
                    searchvalue = e;
                    SearchResult(searchvalue.toString());
                  });
                },
                textInputAction: TextInputAction.search,
                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF270F33),
                                  fontWeight: FontWeight.w600),

                decoration: InputDecoration.collapsed(
                                hintText: 'What are you looking for?',
                                hintStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                focusColor: Color(0xFF2B1137),
                                fillColor: Color(0xFF2B1137),
                                hoverColor: Color(0xFF2B1137),
                              ),
              itemSubmitted: (item) {
                              setState(() {
                                searchvalue = item.service;
                                SearchResult(searchvalue.toString());
                              });

              },
              clearOnSubmit: true,
              key: key,
              suggestions: postRequestProvider.servicesList,
              itemBuilder: (context, item) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(item.service,
                        style: TextStyle(
                            fontSize: 16.0
                        ),),
                    ),
                  ],
                );
              },
              itemSorter: (a, b) {
                return a.service.compareTo(b.service);
              },
              itemFilter: (item, query) {
                return item.service
                    .toLowerCase()
                    .startsWith(query.toLowerCase());
              }),
          )),
          SearchResult(searchvalue),
        ],
      ),
    );

    return PickupLayout(scaffold: widget);
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
            ? Expanded(
                child: Center(
                    child: Text('Loading',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontWeight: FontWeight.w600))))
            : widget.searchValue == '' || widget.searchValue == null
                ? Expanded(
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Search for any service or item you want.',  style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                    )))
                : !snapshot.hasData
                    ? Expanded(
                        child: Center(child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),))
                    : snapshot.hasData && snapshot.data.length != 0
                        ? Expanded(
                            child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  String distance = getDistance(
                                      rawDistance:
                                          '${snapshot.data[index].distance}');
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 90,
                                    margin: const EdgeInsets.only(
                                        bottom: 5, top: 5),
                                    child: ListTile(
                                      onTap: () {
                                        network.postViewed(snapshot.data[index].id);
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
                                              ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                              : 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index].urlAvatar}',
                                        ),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.white,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          snapshot.data[index].businessName.toString().isEmpty|| snapshot.data[index].businessName==null?
                                          '${snapshot.data[index].name} ${snapshot.data[index].userLastName}'.capitalizeFirstOfEach:'${snapshot.data[index].businessName}'
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
                                            Icons.location_on,
                                            color: Color(0xFF9B049B),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Item/Service Not Found', style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                    )))
                            : Expanded(child: Center(child: Text('')));
      },
    );
  }
}
