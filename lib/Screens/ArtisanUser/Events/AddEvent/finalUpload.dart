import 'package:fixme/Screens/ArtisanUser/Events/ManageEvent/manageEventList.dart';
import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/stepthreeEvent.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';


class Finaluplaod extends StatefulWidget {
  var body;
  Finaluplaod(this.body);
  @override
  FinaluplaodState createState() => FinaluplaodState();
}

class FinaluplaodState extends State<Finaluplaod> {


  TextEditingController ticketPrice = TextEditingController();
  TextEditingController ticketCat = TextEditingController();
  List<Widget> myList = [];
  List<TextEditingController> myController1 = [];
  List<TextEditingController> myController2 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        TextEditingController contr1 = TextEditingController();
        TextEditingController contr2 = TextEditingController();
        myController1.add(contr1);
        myController2.add(contr2);
        myList.add(columnList());
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    var data =Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Text('Step 2', style: TextStyle(color: Color(0xFF9B049B)),),
          // )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading:  IconButton(
        //   icon:Icon(Icons.keyboard_backspace, color: Colors.black,),
        //   onPressed: (){
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20,),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:12.0),
              child: Row(
                children: [
                  Text(
                    'Ticket Details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      setState(() {
                        TextEditingController contr1 = TextEditingController();
                        TextEditingController contr2 = TextEditingController();
                        myController1.add(contr1);
                        myController2.add(contr2);
                        myList.add(columnList());
                      });
                    },
                    child: Row(
                      children: [
                        Text('Add'),
                        Icon(Icons.add_circle, color: Colors.grey,),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  myList.length==1?Container():Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(''),
                      IconButton(
                        icon: Icon(Icons.cancel_outlined, color: Colors.red,),
                        onPressed: (){
                          setState(() {
                            myList.removeLast();
                            myController1.removeLast();
                            myController2.removeLast();
                          });

                        },
                      )
                    ],
                  )]+myList,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Consumer<DataProvider>(
                  builder: (context, conData, child) {
                    List count = [];
                      for(var i in myController1+myController2){
                        if(i.text.isEmpty){
                          count.clear();
                        }else{
                          count.add(1);
                        }
                    }
                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 30,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(26)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed: count.isEmpty?null:() {
                           List secondCount = [];
                            var network = Provider.of<WebServices>(context, listen: false);
                            network.loginSetState();
                           secondCount.clear();
                            for(var value in  zip([myController1, myController2])){
                              network.uploadEventCategory(
                                eventId: widget.body['eventId'],
                                ticketCat: value[0].text,
                                ticketPrice: value[1].text,
                                context: context,
                              ).then((value){
                                if(value == true){
                                  secondCount.add(1);
                                  secondCount.length == myController1.length?Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) {
                                        return  ManageEventList();
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ):null;
                                }
                              });

                            }

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
                      ),
                    );}),
            ),
          ],
        ),
      ),
    );
  }


  Widget columnList(){
    var data =Provider.of<DataProvider>(context, listen: false);

    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: MediaQuery.of(context).size.width / 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF9B049B), width: 0.4)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 15),
                    child: Text(
                      'Ticket Name',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
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
                      controller: myController1[myController1.length-1],
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: TextStyle(color: Colors.black38),
                        labelText: 'Ticket Name',
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

                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 15),
                    child: Text(
                      'Ticket Price',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: null,
                      controller: myController2[myController1.length-1],
                      onChanged: (value) {
                        setState(() {
                          // data.setBusinessName(value);
                        });
                      },
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: TextStyle(color: Colors.black38),
                        labelText: '0.00',
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
