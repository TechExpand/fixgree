
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Chat.dart';

class SearchChatPage extends StatefulWidget {
  @override
  _searchchatState createState() => _searchchatState();
}

class _searchchatState extends State<SearchChatPage> {
  var searchvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New message'),
        backgroundColor: Color(0xFFA40C85),
        leading:  InkWell(
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
                       child: Text('To:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                     ),
                      Container(
                        margin: EdgeInsets.only(top:20),
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
    var datas = Provider.of<Utils>(context, listen: false);
    var location = Provider.of<LocationService>(context);

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
                                  return InkWell(
                                    onTap: () {
                                      FirebaseApi.addUserChat(
                                        urlAvatar2: 'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                                        name2: network.firstName,
                                        idArtisan: network.mobile_device_token,
                                        artisanMobile: network.phoneNum ,
                                        userMobile: snapshot.data[index].userMobile,
                                        idUser: snapshot.data[index].idUser,
                                        urlAvatar:
                                        'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                        name: snapshot.data[index].name,
                                      );
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
                                    child: Container(
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
                                    ),
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
