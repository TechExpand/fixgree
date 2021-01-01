
import 'package:fixme/Screens/Chat/callscreens/listen_incoming_call.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<SearchPage> {
  var searchvalue;

  @override
  Widget build(BuildContext context) {
    var widget = Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.black87)),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.15,
                      child: TextFormField(
                        cursorColor: Colors.black87,
                        decoration: InputDecoration(
                          hintText: 'Search',
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
                  ],
                ),
              ),
            ),
          ),
          SearchResult(searchvalue),
        ],
      ),
    );

    return PickupLayout(scaffold: widget);
  }
}

class SearchResult extends StatefulWidget {
  var search_value;

  SearchResult(this.search_value);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchResultState();
  }
}

class SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var location = Provider.of<LocationService>(context);
    // TODO: implement build
    return FutureBuilder(
      future: network.Search(
        searchquery: widget.search_value,
        latitude: location.location_latitude,
        longitude: location.location_longitude,
      ),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Expanded(child: Center(child: Text('Loading')))
            : widget.search_value == '' || widget.search_value == null
                ? Expanded(
                    child: Center(child: Text('Search for Artisans/Services')))
                : !snapshot.hasData
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : snapshot.hasData && snapshot.data.length != 0
                        ? Expanded(
          child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return  Container(
                    child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:8.0, left:8,right:8),
                            child: CircleAvatar(
                                backgroundColor: Colors.white70 ,
                                radius: 18, backgroundImage: NetworkImage(
                                snapshot.data[index].urlAvatar=='no_picture_upload'||
                                    snapshot.data[index].urlAvatar==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                                'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}'
                            )),
                          ),
                          Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                  MediaQuery.of(context)
                                      .size
                                      .width /
                                      1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0,left:5, right:5,bottom: 3),
                                    child: Text(
                                      snapshot.data[index]
                                          .userLastName
                                          .toString() +' '+snapshot.data[index]
                                          .name
                                          .toString(),
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow
                                          .ellipsis,
                                      style: TextStyle(fontWeight:FontWeight.bold),),
                                  ),
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context)
                                      .size
                                      .width /
                                      1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom:8.0,left:5, right:5),
                                    child: Text(
                                      snapshot.data[index]
                                          .serviceArea
                                          .toString(),
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow:
                                      TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
//                                                  Container(
//                                                    width:
//                                                        MediaQuery.of(context)
//                                                                .size
//                                                                .width /
//                                                            1.2,
//                                                    child: Text(
//                                                        snapshot.data[index]
//                                                            ['user_address']
//                                                            .toString(),
//                                                        maxLines: 1,
//                                                        softWrap: true,
//                                                        overflow: TextOverflow
//                                                            .ellipsis),
//                                                  ),
                                Container(

                                  height:1,
                                  color:Colors.black12,
                                  width: MediaQuery.of(context).size.width/1.14,
                                )
                              ])
                        ]),
                  );
              }),
        )
                        : snapshot.data.length == 0
                            ? Expanded(
                                child: Center(
                                    child: Text('Artisans/Service Not Found')))
                            : Expanded(child: Center(child: Text('')));
      },
    );
  }
}
