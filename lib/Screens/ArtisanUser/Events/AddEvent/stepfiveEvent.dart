import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class stepfiveEvent extends StatefulWidget {
  @override
  stepfiveEventState createState() => stepfiveEventState();
}

class stepfiveEventState extends State<stepfiveEvent> {
  @override
  void initState(){
    super.initState();
    Provider.of<LocationService>(context, listen: false).getCurrentLocation();
  }

  var password;
  String startTime = '00:00';
  String endTime = '00:00';
  String endDate = 'dd/mm/yy';
  String startDate = 'dd/mm/yy';

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var datas = Provider.of<Utils>(context, listen: false);
       return Scaffold(
      appBar: AppBar(
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
              padding: const EdgeInsets.only(top:0.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, left: 0),
                        child: Text(
                          'Start Time',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          BottomPicker.time(
                              title:  "Set Start Time",
                              titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                              onSubmit: (index) {
                                print(index);
                                setState(() {
                                  var time = DateTime.parse(index.toString());
                                  startTime = datas.formatTime(time).toString()  ;
                                });

                              },
                              onClose: () {
                                print("Picker closed");
                              },
                              use24hFormat:  false)
                              .show(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Color(0xFF9B049B), width: 0.0)
                          ),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(startTime, style: TextStyle(color: Colors.grey),),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                        child: Text(
                          'End Time',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          BottomPicker.time(
                              title:  "Set End Time",
                              titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                              onSubmit: (index) {
                                setState(() {
                                  var time = DateTime.parse(index.toString());
                                  endTime = datas.formatTime(time).toString() ;
                                });

                              },
                              onClose: () {
                                print("Picker closed");
                              },
                              use24hFormat:  false)
                              .show(context);
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Color(0xFF9B049B), width: 0.0)
                          ),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(endTime, style: TextStyle(color: Colors.grey),),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 12),
              child: Text(
                'Start Date',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            InkWell(
              onTap: (){
                BottomPicker.date(
                    title:  "Set Start Date",
                    titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                    onSubmit: (index) {
                      setState(() {
                        var time = DateTime.parse(index.toString());
                        startDate = datas.formatYear2(time).toString() ;
                      });

                    },
                    onClose: () {
                      print("Picker closed");
                    },
                  )
                    .show(context);
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 0.2,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Color(0xFF9B049B), width: 0.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(startDate, style: TextStyle(color: Colors.grey),),
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_today, color: Color(0xFF9B049B),),
                        )),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'End Date',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: InkWell(
                onTap: (){
                  BottomPicker.date(
                    title:  "Set End Date",
                    titleStyle:  TextStyle(fontWeight:  FontWeight.bold,fontSize:  15,color:  Colors.black),
                    onSubmit: (index) {
                      setState(() {
                        var time = DateTime.parse(index.toString());
                        endDate = datas.formatYear2(time).toString() ;
                      });

                    },
                    onClose: () {
                      print("Picker closed");
                    },
                  )
                      .show(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 0.2,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Color(0xFF9B049B), width: 0.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(endDate, style: TextStyle(color: Colors.grey),),
                          )),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.calendar_today, color: Color(0xFF9B049B),),
                          )),
                    ],
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
                        child:  !network.loginState
                            ? Container(
                          margin: EdgeInsets.only(
                            bottom: 50,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(26)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: startDate == 'dd/mm/yy' ||endDate == 'dd/mm/yy' ||
                                startTime  == '00:00' || endTime == '00:00'
                                ? null
                                : () {
                              print(network.bearer);
                              print(network.userId);
                              network.loginSetState();
                              network.uploadEvent(
                                endDate: endDate,
                                startDate: startDate,
                                endTime: endTime,
                                startTime: startTime,
                                context: context,
                                path: datas.selectedImage.path,
                              );
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
                                  "Upload Event",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ): Padding(
                          padding: const EdgeInsets.only(bottom: 50.0, top: 20),
                          child: Theme(
                              data: Theme.of(context)
                                  .copyWith(
                                  accentColor: Color(
                                      0xFF9B049B)),
                              child:
                              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                strokeWidth: 2,
                                backgroundColor: Colors.white,
                              )),
                        ));
                }
            ),
          ],
        ),
      ),
    );
  }








}
