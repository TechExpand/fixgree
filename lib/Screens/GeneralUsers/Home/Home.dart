import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPage.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  var scafold_key;
  var search;
  var data;

  Home(this.scafold_key, this.data);

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var location = Provider.of<LocationService>(context);
    var data = Provider.of<DataProvider>(context);
    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          forceElevated: true,
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          elevation: 2.5,
          shadowColor: Color(0xFFF1F1FD),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  scafold_key.currentState.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(children: <Widget>[
                    CircleAvatar(
                      child: Text(''),
                      radius: 19,
                      backgroundImage: NetworkImage(
                        network.profile_pic_file_name == 'no_picture_upload' ||
                                network.profile_pic_file_name == null
                            ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                            : 'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      left: 25,
                      top: 24,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFDB5B04), shape: BoxShape.circle),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Image.asset(
                'assets/images/fixme1.png',
                height: 70,
                width: 70,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ListenIncoming();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chat,
                    color: Color(0xFF9B049B),
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                  width: MediaQuery.of(context).size.width / 0.2,
                  height: 60,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return SearchPage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: TextField(
                        enabled: false,
                        obscureText: true,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          enabled: false,
                          prefixIcon: Icon(Icons.search),
                          labelStyle: TextStyle(color: Colors.black38),
                          labelText: 'What are you looking for?',
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Services',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('See all',
                          style: TextStyle(color: Color(0xFF9B049B)))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 12.0, left: 6),
                  height: 150,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                  height: 90,
                                  width: 115,
                                  child: Image.asset(
                                    'assets/images/p1.png',
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Text('UI/UX Designer'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                  height: 90,
                                  width: 115,
                                  child: Image.asset(
                                    'assets/images/p2.png',
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Text('Plumber'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                  height: 90,
                                  width: 115,
                                  child: Image.asset(
                                    'assets/images/p3.png',
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Text('Electrician'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                  height: 90,
                                  width: 115,
                                  child: Image.asset(
                                    'assets/images/p1.png',
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Text('Mechanic'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Ac Repearer'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Dstv installer'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Tailor'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Furniture maker'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Carpenter'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Hair dresser'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Skill Care'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 115,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(
                                Icons.radio,
                                size: 80,
                              ),
                            ),
                            Text('Restaurants'),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Services',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('See all',
                          style: TextStyle(color: Color(0xFF9B049B)))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 12.0, left: 6),
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 115,
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Container(
                                      height: 90,
                                      width: 115,
                                      child: Image.asset(
                                        'assets/images/p3.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Text(
                                        '5.0',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Text(
                                      '(9)',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 7.0),
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 14,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, left: 8, right: 8),
                                  child: Container(
                                    child: Text(
                                      'Design you an inspired brochure for your branch',
                                      style: TextStyle(fontSize: 13),
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5.0, top: 8),
                                      child: Text(
                                        'From 150\₦',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF27AE60)),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nearby Shops',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('See all',
                          style: TextStyle(color: Color(0xFF9B049B)))
                    ],
                  ),
                ),
                FutureBuilder(
                    future: network.NearbyShop(
                        latitude: location.location_latitude,
                        longitude: location.location_longitude),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Loading Shops',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            )
                          : snapshot.hasData && !snapshot.data.isEmpty
                              ? Container(
                                  height: 140,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return ArtisanPage(
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
                                          padding: const EdgeInsets.only(
                                              top: 12.0, left: 6),
                                          height: 140,
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                child: Text(''),
                                                radius: 35,
                                                backgroundImage: NetworkImage(
                                                  snapshot.data[index]
                                                                  .urlAvatar ==
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                    '${snapshot.data[index].name}'),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                    '${snapshot.data[index].userLastName}'),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : snapshot.data.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'No Nearby Shops',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  : Container();
                    }),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nearby Artisans',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('See all',
                          style: TextStyle(color: Color(0xFF9B049B)))
                    ],
                  ),
                ),
                FutureBuilder(
                    future: network.NearbyArtisans(
                        latitude: location.location_latitude,
                        longitude: location.location_longitude),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Loading Artisans',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            )
                          : snapshot.hasData && !snapshot.data.isEmpty
                              ? Container(
                                  height: 140,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return ArtisanPage(
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
                                          padding: const EdgeInsets.only(
                                              top: 12.0, left: 6),
                                          height: 140,
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                child: Text(''),
                                                radius: 35,
                                                backgroundImage: NetworkImage(
                                                  snapshot.data[index]
                                                                  .urlAvatar ==
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                    '${snapshot.data[index].name}'),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                    '${snapshot.data[index].userLastName}'),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : snapshot.data.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'No Nearby Artisans',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  : Container();
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Introduce your friends to the fastest way to get things done',
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(7)),
                    child: FlatButton(
                      onPressed: () {
//                    formKey.currentState.validate();
//                      Navigator.pushReplacement(context,
//                        MaterialPageRoute(
//                            builder: (context) => Login()),
//                      );
                      },
                      color: Color(0xFF9B049B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width / 1.3,
                              minHeight: 45.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Invite Friends",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
