import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/stepfiveEvent.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:provider/provider.dart';

class ManageEventRole extends StatefulWidget {
  var data;
  ManageEventRole(this.data);
  @override
  ManageEventRoleState createState() => ManageEventRoleState();
}

class ManageEventRoleState extends State<ManageEventRole> {
  int eventId = 0;

  @override
  void initState() {
    super.initState();
    for(var value in widget.data.eventTicket){
      eventId = value['event_id'];
    }
  }

  var password;
  TextEditingController  user = TextEditingController();
  TextEditingController level = TextEditingController();
  TextEditingController id =  TextEditingController();
  var _currentSelectedValue = 'Admin';
  var _currencies = [
    "Admin",
    "Event Manager",
    "Sales Manager",
    "Crowd Controller",
  ];


 String checkRole(currentSelectedValue){
    if(currentSelectedValue == 'Admin'){
      return 'admin';
    }else if(currentSelectedValue == 'Event Manager'){
      return 'event_manager';
    }else if(currentSelectedValue == 'Sales Manager'){
      return 'sales_manager';
    }else{
      return 'crowd_control';
    }
  }

  @override
  Widget build(BuildContext context) {
    var data =Provider.of<DataProvider>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Text('Step 4', style: TextStyle(color: Color(0xFF9B049B)),),
          // )
        ],
        backgroundColor: Colors.white,
        title: Text('Manage Event',  style: TextStyle(color:  Color(0xFF9B049B)),),
        leading:  IconButton(
          icon:Icon(Icons.keyboard_backspace, color:  Color(0xFF9B049B),),
          onPressed: (){
            Navigator.pop(context);
          },
        ),

      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20,),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 15),
              child: Row(
                children: [
                  Text(
                    'Search for user',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    ' (name, email or phone number)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                _searchUser(context);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                width: MediaQuery.of(context).size.width / 0.2,
                height: 55,
                child: TextFormField(
                  enabled: false,
                  onFieldSubmitted: (v){
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  textCapitalization:
                  TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  maxLines: null,
                  controller: user,
                  onChanged: (value) {
                    setState(() {
                      data.sethomeAdress(value);
                    });

                  },
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                  color: Color(0xFF9B049B), width: 1.3),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.black38),
                    hintText: user.text,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF9B049B), width: 1.3),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF9B049B), width:1.3),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF9B049B), width: 1.3),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 0),
              child: Text(
                'Access Level',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              height: 55,
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(width: 1.3,color: Color(0xFF9B049B)),
                          borderRadius: BorderRadius.circular(12.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.3,color: Color(0xFF9B049B)),
                            borderRadius: BorderRadius.circular(12.0)),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.3,color: Color(0xFF9B049B)),
                            borderRadius: BorderRadius.circular(12.0))),
                    isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedValue,
                        iconEnabledColor: Color(0xFF9B049B),
                        iconDisabledColor: Color(0xFF9B049B),
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _currentSelectedValue = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle( fontSize: 12.0, fontWeight: FontWeight.bold),),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Consumer<DataProvider>(
                  builder: (context, conData, child) {
                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 30,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed:
                        user.text.isEmpty
                              ? null
                              : () {
                            network.uploadEventManager(
                              eventId: eventId.toString() ,
                              context: context,
                              managerRole: checkRole(_currentSelectedValue),
                              managerUserID: id.text,
                              uplaoderRole: widget.data.managerRole.toString(),
                            );
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          color: Color(0xFF9B049B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width / 1.4,
                                  minHeight: 45.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Add User",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );}),
            ),



            Center(
              child: Expanded(
                child: Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.only(top: 8,bottom: 10,),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF9B049B), width: 1.5),
                        borderRadius: BorderRadius.circular(8.4)),
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width*0.95,
                            height: 33,
                            decoration: BoxDecoration(
                                color: Color(0xFF9B049B),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(7) ,
                                    topLeft: Radius.circular(7))),
                            child: Center(child: Text('Access Levels',
                              style: TextStyle(color: Colors.white),))
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top:4.0),
                            child: Scrollbar(
                              child: ListView(
                                children: [
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text("Admin", style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text("This user can add or remove other users added to manage this event An admin also has the privileges of an Event Manager, Sales Manager and Crowd Controller"),
                                    ),
                                  Divider(
                                    thickness: 1.5,
                                  )
                                  ],
                            ),






                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("Event Manager", style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("An Event Manager will be able to edit information this Event, view sales records and handle ticket entry validations."),
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                      )
                                    ],
                                  ),




                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("Sales Manager", style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("A Sales Manager will only be able to view records of tickets sold."),
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                      )
                                    ],
                                  ),




                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("Crowd Controller", style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text("This user will only be able to manage event ticket entries and would not be able to view or edit any infomation about this event."),
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                      )
                                    ],
                                  ),
                                ],
                              )
                                ],
                              )
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  _searchUser(context){
    var searchvalue;
    return  showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
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
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.97,
                                      child: TextFormField(
                                        cursorColor: Colors.black87,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(fontSize: 14),
                                          hintText: 'Search for user: name, email, or phone number',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
//                            border: InputBorder.none, counterText: ''
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            searchvalue = value;
                                            SearchResult(searchvalue, user, id);
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
                        SearchResult(searchvalue, user, id),
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}











class SearchResult extends StatefulWidget {
  final searchValue;
  final user;
  final id;

  SearchResult(this.searchValue, this.user, this.id);

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
            child: Center(child: Text('Search for User',
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
                        widget.user.text = "${snapshot.data[index]
                            .userLastName.toString()} ${snapshot.data[index]
                            .name
                            .toString()}";
                        widget.id.text = "${snapshot.data[index]
                            .id.toString()}";
                        Navigator.pop(context);
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
                            ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                            : 'https://uploads.fixme.ng/thumbnails/${snapshot.data[index].urlAvatar}'),
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
                child: Text('User Not Found',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)))
            : Expanded(child: Center(child: Text('')));
      },
    );
  }
}

