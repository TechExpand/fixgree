import 'package:bottom_picker/bottom_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/stepfourEvent.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../DummyData.dart';


class stepthreeEvent extends StatefulWidget {
  @override
  stepthreeEventState createState() => stepthreeEventState();
}

class stepthreeEventState extends State<stepthreeEvent> {
  @override
  void initState(){
    super.initState();
    Provider.of<LocationService>(context, listen: false).getCurrentLocation();
  }
  String  selectedCountry = '';
  var password;
  TextEditingController  city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context, listen: false);
    LgaProvider state =  Provider.of<LgaProvider>(context, listen: false);

    result = state.allLgaList;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Step 3', style: TextStyle(color: Color(0xFF9B049B)),),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading:  IconButton(
          icon:Icon(Icons.keyboard_backspace, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0, left: 8),
              child: Text(
                'Country',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Color(0xFF9B049B), width: 0.0)
                ),
                width: MediaQuery.of(context).size.width / 0.2,
                height: 55,
                child: TextButton(
                  onPressed: (){
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false, // optional. Shows phone code before the country name.
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country.name;
                        });
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(" ${selectedCountry==''?'Country ':selectedCountry}". toUpperCase(), style: TextStyle(color: Colors.black38))),
                      Align(
                          alignment: Alignment.bottomRight,
                          child:Icon(Icons.arrow_drop_down, color:  Color(0xFF9B049B),))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0, left: 8),
              child: Text(
                'State',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Color(0xFF9B049B), width: 0.0)
                ),
                width: MediaQuery.of(context).size.width / 0.2,
                height: 55,
                child: TextButton(
                  onPressed: (){
                    bankDialog(context, setState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(" ${state.seletedinfo==null?'State ':state.seletedinfo.name}". toUpperCase(), style: TextStyle(color: Colors.black38))),
                      Align(
                          alignment: Alignment.bottomRight,
                          child:Icon(Icons.arrow_drop_down, color:  Color(0xFF9B049B),))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0, left: 8),
              child: Text(
                'City',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                width: MediaQuery.of(context).size.width / 0.2,
                height: 55,
                child: TextFormField(
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
                  controller: city,
                  onChanged: (value) {
                    setState(() {
                      data.sethomeAdress(value);
                    });

                  },
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    isDense: true,
                    labelStyle: TextStyle(color: Colors.black38),
                    labelText: 'City',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF9B049B), width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF9B049B), width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF9B049B), width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),

            ),

           SizedBox(height: 30,),
            Consumer<DataProvider>(
                builder: (context, conData, child) {
                  return
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 50,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(26)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: selectedCountry.isEmpty ||city.text.isEmpty ||
                                state.seletedinfo==null
                                ? null
                                : () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return stepfourEvent();
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
                               data.eventCountry = selectedCountry;
                              data.eventState =  state.seletedinfo.name;
                              data.eventCity = city.text;
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            color: Color(0xFF9B049B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(26)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width / 1.3,
                                    minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "CONTINUE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ));
                }
            ),
          ],
        ),
      ),
    );
  }







  List<StateInfo> result = [];

  void searchLga(userInputValue) {
    LgaProvider postRequestProvider =
    Provider.of<LgaProvider>(context, listen: false);
    result = postRequestProvider.allLgaList
        .where((lga) => lga.name.toString()
        .toLowerCase()
        .contains(userInputValue.toLowerCase()))
        .toList();
  }


  bankDialog(ctx, set) {
    LgaProvider postRequestProvider =
    Provider.of<LgaProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {


              return AlertDialog(
                title: TextFormField(
                  onChanged: (value) {
                    setStates(() {
                      searchLga(value);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Search State',
                    labelStyle: TextStyle(color: Colors.black),
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 500,
                          child: ListView.builder(
                            itemCount:  result.length,
                            itemBuilder: (context, index) {
                              result.sort((a, b) {
                                var ad = a.name;
                                var bd = b.name;
                                var s = ad.compareTo(bd);
                                return s;
                              });

                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  postRequestProvider.changeSelectedLGA(result[index]);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFF270F33)
                                        .withOpacity(0.6),
                                    child: Text(
                                        result[index]
                                            .name.toString()
                                            .substring(0, 2),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  title: Text('${result[index].name}',  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((v) {
      set(() {});
    });
  }

}
