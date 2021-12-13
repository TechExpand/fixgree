// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:fixme/Model/service.dart';
// import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
// import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/listen_incoming_call.dart';
// import 'package:fixme/Services/location_service.dart';
// import 'package:fixme/Services/network_service.dart';
// import 'package:fixme/Services/postrequest_service.dart';
// import 'package:fixme/Widgets/Rating.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:fixme/Utils/utils.dart';
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchState createState() => _SearchState();
// }
//
// class _SearchState extends State<SearchPage> {
//   var searchvalue;
//
//
//   GlobalKey<AutoCompleteTextFieldState<Services>> key = new GlobalKey();
//
//   AutoCompleteTextField searchTextField;
//
//   TextEditingController controller = new TextEditingController();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     PostRequestProvider postRequestProvider =
//     Provider.of<PostRequestProvider>(context);
//     var widget = Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Search for a service',
//             style: GoogleFonts.poppins(
//                 color: Color(0xFF9B049B),
//                 fontSize: 18,
//                 height: 1.4,
//                 fontWeight: FontWeight.w600)),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
//         ),
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Hero(
//             tag: 'searchButton',
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 500),
//                   height: 50,
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.only(left: 12),
//                   margin: const EdgeInsets.only(
//                       bottom: 15, left: 12, right: 12, top: 15),
//                   decoration: BoxDecoration(
//                       color: Color(0xFFFFFFFF),
//                       border: Border.all(color: Color(0xFFF1F1FD)),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Color(0xFFF1F1FD).withOpacity(0.5),
//                             blurRadius: 15.0,
//                             offset: Offset(0.3, 1.0))
//                       ],
//                       borderRadius: BorderRadius.all(Radius.circular(35))),
//               child:searchTextField = AutoCompleteTextField<Services>(
//                 textSubmitted: (e){
//                   setState(() {
//                     searchvalue = e;
//                     SearchResult(searchvalue.toString());
//                   });
//                 },
//                 textInputAction: TextInputAction.search,
//                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Color(0xFF270F33),
//                                   fontWeight: FontWeight.w600),
//
//                 decoration: InputDecoration.collapsed(
//                                 hintText: 'What are you looking for?',
//                                 hintStyle: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w600),
//                                 focusColor: Color(0xFF2B1137),
//                                 fillColor: Color(0xFF2B1137),
//                                 hoverColor: Color(0xFF2B1137),
//                               ),
//               itemSubmitted: (item) {
//                               setState(() {
//                                 searchvalue = item.service;
//                                 SearchResult(searchvalue.toString());
//                               });
//
//               },
//               clearOnSubmit: true,
//               key: key,
//               suggestions: postRequestProvider.servicesList,
//               itemBuilder: (context, item) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Text(item.service,
//                         style: TextStyle(
//                             fontSize: 16.0
//                         ),),
//                     ),
//                   ],
//                 );
//               },
//               itemSorter: (a, b) {
//                 return a.service.compareTo(b.service);
//               },
//               itemFilter: (item, query) {
//                 return item.service
//                     .toLowerCase()
//                     .startsWith(query.toLowerCase());
//               }),
//           )),
//           SearchResult(searchvalue),
//         ],
//       ),
//     );
//
//     return PickupLayout(scaffold: widget);
//   }
// }
//
// class SearchResult extends StatefulWidget {
//   final searchValue;
//
//   SearchResult(this.searchValue);
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return SearchResultState();
//   }
// }
//
// class SearchResultState extends State<SearchResult> {
//   String getDistance({String rawDistance}) {
//     String distance;
//     distance = '$rawDistance' + 'km';
//     return distance;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var network = Provider.of<WebServices>(context, listen: false);
//     var location = Provider.of<LocationService>(context);
//     return FutureBuilder(
//       future: network.search(
//         searchquery: widget.searchValue,
//         latitude: location.locationLatitude,
//         longitude: location.locationLongitude,
//       ),
//       builder: (context, snapshot) {
//         return snapshot.connectionState == ConnectionState.waiting
//             ? Expanded(
//                 child: Center(
//                     child: Text('Loading',
//                         style: TextStyle(
//                             color: Color(0xFF333333),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600))))
//             : widget.searchValue == '' || widget.searchValue == null
//                 ? Expanded(
//                     child: Center(child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Search for any service or item you want.',  style: TextStyle(
//                           color: Color(0xFF333333),
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600)),
//                     )))
//                 : !snapshot.hasData
//                     ? Expanded(
//                         child: Center(child: Theme(
//                                   data: Theme.of(context)
//                                       .copyWith(accentColor: Color(0xFF9B049B)),
//                                   child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                      strokeWidth: 2,
//                                               backgroundColor: Colors.white,
// )),))
//                     : snapshot.hasData && snapshot.data.length != 0
//                         ? Expanded(
//                             child: ListView.separated(
//                                 separatorBuilder: (context, index) {
//                                   return Divider();
//                                 },
//                                 padding:
//                                     const EdgeInsets.only(left: 5, right: 5),
//                                 itemCount: snapshot.data.length,
//                                 itemBuilder: (context, index) {
//                                   String distance = getDistance(
//                                       rawDistance:
//                                           '${snapshot.data[index].distance}');
//                                   return Container(
//                                     alignment: Alignment.center,
//                                     height: 90,
//                                     margin: const EdgeInsets.only(
//                                         bottom: 5, top: 5),
//                                     child: ListTile(
//                                       onTap: () {
//                                         network.postViewed(snapshot.data[index].id);
//                                         Navigator.push(
//                                           context,
//                                           PageRouteBuilder(
//                                             pageBuilder: (context, animation,
//                                                 secondaryAnimation) {
//                                               return ArtisanPageNew(
//                                                   snapshot.data[index]);
//                                             },
//                                             transitionsBuilder: (context,
//                                                 animation,
//                                                 secondaryAnimation,
//                                                 child) {
//                                               return FadeTransition(
//                                                 opacity: animation,
//                                                 child: child,
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                       leading: CircleAvatar(
//                                         child: Text(''),
//                                         radius: 35,
//                                         backgroundImage: NetworkImage(
//                                           snapshot.data[index].urlAvatar ==
//                                                       'no_picture_upload' ||
//                                                   snapshot.data[index]
//                                                           .urlAvatar ==
//                                                       null
//                                               ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
//                                               : 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index].urlAvatar}',
//                                         ),
//                                         foregroundColor: Colors.white,
//                                         backgroundColor: Colors.white,
//                                       ),
//                                       title: Padding(
//                                         padding: const EdgeInsets.only(top: 10),
//                                         child: Text(
//                                           snapshot.data[index].businessName.toString().isEmpty|| snapshot.data[index].businessName==null?
//                                           '${snapshot.data[index].name} ${snapshot.data[index].userLastName}'.capitalizeFirstOfEach:'${snapshot.data[index].businessName}'
//                                               .capitalizeFirstOfEach,
//                                           style: TextStyle(
//                                               color: Color(0xFF333333),
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       subtitle: Column(
//                                         children: [
//                                           Wrap(
//                                             children: [
//                                               Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Text(
//                                                   '${snapshot.data[index].serviceArea}'
//                                                       .capitalizeFirstOfEach,
//                                                   style: TextStyle(
//                                                       color: Color(0xFF333333),
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 8),
//                                             child: StarRating(
//                                                 rating: double.parse(snapshot
//                                                     .data[index].userRating
//                                                     .toString())),
//                                           )
//                                         ],
//                                       ),
//                                       trailing: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.location_on,
//                                             color: Color(0xFF9B049B),
//                                             size: 23,
//                                           ),
//                                           Text(
//                                             '$distance',
//                                             style: TextStyle(
//                                                 color: Color(0xFF333333),
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           )
//                         : snapshot.data.length == 0
//                             ? Expanded(
//                                 child: Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text('Item/Service Not Found', style: TextStyle(
//                                           color: Color(0xFF333333),
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600)),
//                                     )))
//                             : Expanded(child: Center(child: Text('')));
//       },
//     );
//   }
// }












import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fixme/Model/service.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chat.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/listen_incoming_call.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:transparent_image/transparent_image.dart';

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
  ScrollController scrollController = ScrollController();
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
      future: network.searchV1(
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
          child:  StaggeredGridView.countBuilder(
            //   itemExtent: 2000,
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return snapshot.data[index].resultType=='product'?InkWell(
                  onTap: (){
                    _viewProduct(snapshot.data[index].user, data: snapshot.data[index]);
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
                            image: snapshot.data[index].productImages==null?'https://uploads.fixme.ng/thumbnails/${snapshot.data[index].productImages}':"https://uploads.fixme.ng/thumbnails/${snapshot.data[index].productImages}",fit: BoxFit.cover,),
                          footer: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                children: [
                                  Text("${snapshot.data[index].product_name}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("₦${snapshot.data[index].price}", style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight
                                      .w400),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    height: 22,
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons
                                              .location_on,
                                          color: Colors
                                              .white,
                                          size: 14,
                                        ),
                                        Text(
                                          '${snapshot.data[index].distance}km away',
                                          style: TextStyle(
                                              color: Colors
                                                  .white,
                                              fontSize:
                                              12,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ):InkWell(
                  onTap: (){
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
                            image: snapshot.data[index].user.urlAvatar==null?'https://uploads.fixme.ng/thumbnails/${snapshot.data[index].user.urlAvatar}':"https://uploads.fixme.ng/thumbnails/${snapshot.data[index].user.urlAvatar}",fit: BoxFit.cover,),
                          footer: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                children: [
                                  Text("${snapshot.data[index].product_name}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("${snapshot.data[index].user.serviceArea}", style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    height: 22,
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons
                                              .location_on,
                                          color: Colors
                                              .white,
                                          size: 14,
                                        ),
                                        Text(
                                          '${snapshot.data[index].distance}km away',
                                          style: TextStyle(
                                              color: Colors
                                                  .white,
                                              fontSize:
                                              12,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ),
                                      ],
                                    ),
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
              }) ,
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
                         // for (dynamic item in data.productImages)
                            Hero(
                              tag:  'https://uploads.fixme.ng/originals/${data.productImages}',
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context,
                                          animation,
                                          secondaryAnimation) {
                                        return PhotoView(
                                          'https://uploads.fixme.ng/originals/${data.productImages}',
                                          'https://uploads.fixme.ng/originals/${data.productImages}',
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
                                  height: 300,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 300,
                                          child: Image.network(
                                            'https://uploads.fixme.ng/thumbnails/${data.productImages}',
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
                          network.sendSms(price:data.price ,product_name: data.product_name, phone:userData.userMobile.toString(),context: context);
                          network.sendRoboco(price:data.price ,product_name: data.product_name, phone:userData.userMobile.toString(),context: context);
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
                                        userData.businessName==null||userData.businessName.toString()==''?'${userData.name} ${userData.userLastName}':userData.businessName.toString()
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
