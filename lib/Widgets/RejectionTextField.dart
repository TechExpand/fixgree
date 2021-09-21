import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RejectionTextField extends StatefulWidget {
  var index;
  var docid;
  bool type;
  RejectionTextField(this.index, this.docid, this.type);
  @override
  _RejectionTextFieldState createState() => _RejectionTextFieldState();
}

class _RejectionTextFieldState extends State<RejectionTextField> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Reason For Rejection', style: TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.keyboard_backspace, color: Colors.black,),),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onFieldSubmitted: (v){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              maxLength: 1500,
              onChanged: (value) {
                setState(() {
                  //data.setOverView(value);
                });

              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF9B049B), width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF9B049B), width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                border: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF9B049B), width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            child: FlatButton(
              onPressed:controller.text.isEmpty?null:widget.type==false?(){
                FirebaseApi.updateNotificationInvoice(
                    widget.index.invoice_id.toString(),
                    'initiate_bid', 'rejectbids');
                FirebaseApi.deleteNotificationInvoice(
                    widget.index.bid_id.toString(),
                    widget.index.invoice_id.toString());
                Navigator.pop(context);
                Navigator.pop(context);
              }:() {
                var conData = Provider.of<DataProvider>(context, listen: false);
                var network = Provider.of<WebServices>(context, listen: false);
                conData.setSelectedBottomNavBar(1);
                FirebaseApi.clearSingleJobBids(widget.docid);
                FirebaseApi.updateNotificationBid(widget.index.bid_id, 'bid_completed', 'reject');
                network.rejectJob(
                  bidderId: widget.index.bidder_id,
                  jobId: widget.index.job_id,
                  reason: controller.text.toString(),
                  userId: network.userId,
                  bidId: widget.index.bid_id,
                  context:context,
                );
                Navigator.pop(context);
                Navigator.pop(context);

              },
              color: Color(0xFF9B049B),
              disabledColor: Color(0x909B049B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26)),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth:
                      MediaQuery
                          .of(context)
                          .size
                          .width / 1.3,
                      minHeight: 45.0),
                  alignment: Alignment.center,
                  child: Text(
                    "REJECT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
