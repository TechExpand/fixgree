import 'dart:convert';

import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanResult extends StatefulWidget {
  var data;
   ScanResult({Key key, this.data}) : super(key: key);


  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  List userDetail= [];

  validate(status){
    if(status == 'UN-USED'){
      return 'EVENT ENTRY';
    }else if(status == 'EVENT ENTRY'){
      return 'EVENT EXIT';
    }else if(status == 'EVENT EXIT'){
      return 'EVENT ENTRY';
    }
  }
  filter(context){
    var network = Provider.of<WebServices>(context, listen: false);
    var body = json.decode(network.eventPurchaseList.toString());
    for(var value in body['eventPurchases']){
      if(value['referenceToken'] == widget.data){
        userDetail.add(value);
        network.updateTicketStatus(ticketID: value['id'],
            context: context,
            status: validate(value['ticket_status']));
        // network.
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filter(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
          icon: Icon(
          Icons.keyboard_backspace,
          color: Color(0xFF9B049B),
        ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
          backgroundColor: Colors.white,),
        body: Container(
child: userDetail.isEmpty?Center(
  child: Text('Not Found', style: TextStyle(fontSize: 23,
      fontWeight: FontWeight.bold),),
):Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage('https://uploads.fixme.ng/thumbnails/' +
              userDetail[0]['event_info']['eventImages'][0]['imageFileName']
                  .toString(),),
          foregroundColor: Colors.white,
        ),
      ),
    ),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text('STATUS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
    Text(' ${validate(userDetail[0]['ticket_status'])}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
  ],
),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Ticker:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        Text(' ${userDetail[0]['ticket_category']}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('FIRST NAME:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        Text(' ${userDetail[0]['purchase_user_info']['user_first_name']}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('DATE PURCHASED:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        Text(' ${userDetail[0]['date_purchased']}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
      ],
    ),


  ],
),
    ));
  }
}
