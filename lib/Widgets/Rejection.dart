

import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RejectionTextField.dart';

class RejectionList extends StatefulWidget {
  var index;
  var docid;
  RejectionList(this.index, this.docid);
  @override
  _RejectionListState createState() => _RejectionListState();
}

class _RejectionListState extends State<RejectionList> {
String _commentController = 'I will pay later';
  var value = 0;

  setValue(e){
    if(e==0){
      setState(() {
        value = e;
      });
    }else if(e==1){
      setState(() {
        value = e;
      });
    }else if(e==2){
      setState(() {
        value = e;
      });
    }else if(e==3){
      setState(() {
        value = e;
      });
    }else if(e==4){
      setState(() {
        value = e;
      });
    }
  }

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
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          RadioListTile(
              title: Text('I will pay later'),
              value: 0,
              groupValue: value,
              onChanged: (state){
                _commentController = "I will pay later";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text('Price is too high'),
              value: 1,
              groupValue: value,
              onChanged: (state){
                _commentController = "Price is too high";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text('I am no longer interested in the item or service'),
              value: 2,
              groupValue: value,
              onChanged: (state){
                _commentController = "I am no longer interested in the item or service";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text('Cost sent different from cost seen on the product'),
              value: 3,
              groupValue: value,
              onChanged: (state){
                _commentController = "Cost sent different from cost seen on the product";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text('I did not agree to this price'),
              value: 4,
              groupValue: value,
              onChanged: (state){
                _commentController = "I did not agree to this price";
                setValue(state);
              }),
          Divider(thickness: 8, color:  Colors.black12,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return RejectionTextField(widget.index, widget.docid); //SignUpAddress();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),

              );

            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text('Other', style: TextStyle(color: Colors.black, fontSize: 16),),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black38, size: 28,)
                ],
              ),
            ),
          ),

         Padding(
           padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
           child: FlatButton(
                          onPressed:() {
                            var conData = Provider.of<DataProvider>(context, listen: false);
                            var network = Provider.of<WebServices>(context, listen: false);
                            conData.setSelectedBottomNavBar(1);
                            FirebaseApi.clearSingleJobBids(widget.docid);
                            _commentController == 'I will pay later'?null: FirebaseApi.updateNotificationBid(widget.index.bid_id, 'bid_completed', 'reject');
                            network.rejectJob(
                              bidderId: widget.index.bidder_id,
                              jobId: widget.index.job_id,
                              reason: _commentController,
                              userId: network.userId,
                              bidId: widget.index.bid_id,
                                context:context,
                            );
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
