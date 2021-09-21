

import 'dart:ui';

import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RejectionTextField.dart';

class RejectionList extends StatefulWidget {
  var index;
  var docid;
  bool type;
  RejectionList(this.index, this.docid, this.type);
  @override
  _RejectionListState createState() => _RejectionListState();
}

class _RejectionListState extends State<RejectionList> {
  String _commentController = '';
  void initState(){
    super.initState();
     _commentController = widget.type==true?'The task has not been completed':'I will pay later';
  }

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
              title: Text(widget.type==true?'The task has not been completed':'I will pay later'),
              value: 0,
              groupValue: value,
              onChanged: (state){
                _commentController = widget.type==true?'The task has not been completed':"I will pay later";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text(widget.type==true?'I have not received the items':'Price is too high'),
              value: 1,
              groupValue: value,
              onChanged: (state){
                _commentController = widget.type==true?'I have not received the items':"Price is too high";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text(widget.type==true?'I am not satisfied with the items':'I am no longer interested in the item or service'),
              value: 2,
              groupValue: value,
              onChanged: (state){
                _commentController = widget.type==true?'I am not satisfied with the items':"I am no longer interested in the item or service";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text(widget.type==true?'I do not like the job':'Cost sent different from cost seen on the product'),
              value: 3,
              groupValue: value,
              onChanged: (state){
                _commentController = widget.type==true?'I do not like the job':"Cost sent different from cost seen on the product";
                setValue(state);
              }),
          Divider(),
          RadioListTile(
              title: Text(widget.type==true?'Bad attitude':'I did not agree to this price'),
              value: 4,
              groupValue: value,
              onChanged: (state){
                _commentController = widget.type==true?'Bad attitude':"I did not agree to this price";
                setValue(state);
              }),
         widget.type==true?
          Column(
            children: [
              Divider(),
              RadioListTile(
                  title: Text('Delay  in delivery'),
                  value: 4,
                  groupValue: value,
                  onChanged: (state){
                    _commentController = 'Delay  in delivery';
                    setValue(state);
                  }),
            ],
          ):Container(),

          Divider(thickness: 8, color:  Colors.black12,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return RejectionTextField(widget.index, widget.docid, widget.type); //SignUpAddress();
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
                          onPressed: widget.type==false?(){
                            if(_commentController == 'I will pay later'){
                              return showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 8, sigmaY: 8),
                                      child: AlertDialog(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0))),
                                        content: Container(
                                          height: 190,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text(
                                                'NOTE!!',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xFF9B049B),
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                            Container(
                                                    padding: EdgeInsets.only(
                                                        top: 15, bottom: 15),
                                                    child: Center(
                                                      child: Text(
                                                        'Please go to your notification and confirm this payment when you are ready',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors.black54,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),

                                              ButtonBar(
                                                  alignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Material(
                                                      borderRadius: BorderRadius
                                                          .circular(26),
                                                      elevation: 2,
                                                      child: Container(
                                                        height: 35,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Color(
                                                                    0xFF9B049B)),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(26)),
                                                        child: FlatButton(
                                                          onPressed: () {
                                                            var conData = Provider.of<DataProvider>(context, listen: false);
                                                            var network = Provider.of<WebServices>(context, listen: false);
                                                            conData.setSelectedBottomNavBar(1);
                                                            FirebaseApi.deleteNotificationInvoice(
                                                                widget.index.bid_id.toString(),
                                                                widget.index.invoice_id.toString());
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          },
                                                          color: Color(
                                                              0xFF9B049B),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  26)),
                                                          padding: EdgeInsets
                                                              .all(0.0),
                                                          child: Ink(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    26)),
                                                            child: Container(
                                                              constraints: BoxConstraints(
                                                                  maxWidth: 190.0,
                                                                  minHeight: 53.0),
                                                              alignment: Alignment
                                                                  .center,
                                                              child: Text(
                                                                "OK",
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });



                            }else{
                              var conData = Provider.of<DataProvider>(context, listen: false);
                              var network = Provider.of<WebServices>(context, listen: false);
                              conData.setSelectedBottomNavBar(1);
                              FirebaseApi.updateNotificationInvoice(
                                  widget.index.invoice_id.toString(),
                                  'initiate_bid', 'rejectbids');
                              FirebaseApi.deleteNotificationInvoice(
                                  widget.index.bid_id.toString(),
                                  widget.index.invoice_id.toString());
                              Navigator.pop(context);
                            }


                            // network.rejectJob(
                            //   bidderId: widget.index.bidder_id,
                            //   jobId: widget.index.job_id,
                            //   reason: _commentController,
                            //   userId: network.userId,
                            //   bidId: widget.index.bid_id,
                            //   context:context,
                            // );
                          }:()async{
                            var conData = Provider.of<DataProvider>(context, listen: false);
                            var network = Provider.of<WebServices>(context, listen: false);
                            conData.setSelectedBottomNavBar(1);
                            FirebaseApi.clearSingleJobBids(widget.docid);
                             FirebaseApi.updateNotificationBid(widget.index.bid_id, 'bid_completed', 'reject');
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
