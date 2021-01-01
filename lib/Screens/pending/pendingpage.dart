import 'package:flutter/material.dart';

class PendingScreen extends StatefulWidget {
  PendingScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PendingScreenState createState() => PendingScreenState();
}

class PendingScreenState extends State<PendingScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          //title: Text(widget.title),
          actions: [
            IconButton(icon: Icon(Icons.picture_in_picture), onPressed: null),
            //TextField(),
            Expanded(child: Container(
              // color: Colors.red,

            child: TextField(
              decoration: InputDecoration(
                // fillColor:  Color(0xFF9B049B),
                labelText: 'What are you looking for?',
                labelStyle: TextStyle(color:  Color(0xFF9B049B)),
                prefixIcon: Icon(Icons.search, color:  Color(0xFF9B049B),),
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.all(Radius.circular(9),),

                  )
              ),
            ),
            )),
            IconButton(icon: Icon(Icons.chat, color:  Color(0xFF9B049B),), onPressed: null),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(color: Color(0xFF9B049B),
              child: Center(child: 
                Padding(
                  padding: const EdgeInsets.only(top:20.0, bottom: 20.0),
                  child: Text('Wallet  Balance N19,500', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),),),
              SizedBox(height: 10,),

              Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('22 July 2018'),
                Text('BALANCE N19, 500'),
              ],),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width/4.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF9B049B),
                    
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Design', textAlign: TextAlign.center, style: TextStyle(color:Colors.white,),),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 100,
                   
                            child: Column(children: [
                              ClipRRect(child: Text('Banking And Food Delivery', style: TextStyle(fontSize: 15.0, fontWeight:FontWeight.bold),)),
                              ClipRRect(child: Text('Spicing catering ltd')),
                      
                    ],),
                  ),
                  SizedBox(width: 2),

                  Expanded(
                      child: Row(children: [
                      Icon(Icons.remove, color: Colors.red, size: 14.0,),
                      Text('N 12,000'),
                      Icon(Icons.arrow_downward, color: Colors.red, size: 14.0,),
                    ],),
                  )
                ]
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width/4.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF9B049B),
                    
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Design', textAlign: TextAlign.center, style: TextStyle(color:Colors.white,),),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 100,                   
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      ClipRRect(child: Text('Banking And Food Delivery', style: TextStyle(fontSize: 15.0, fontWeight:FontWeight.bold),)),
                      ClipRRect(child: Text('Spicing catering ltd')),                      
                    ],),
                  ),
                  SizedBox(width: 2),

                  Expanded(
                      child: Row(children: [
                      Icon(Icons.remove, color: Colors.red, size: 14.0,),
                      Text('N 12,000'),
                      Icon(Icons.arrow_downward, color: Colors.red, size: 14.0,),
                    ],),
                  )
                ]
              ),
              ],),

          Row(
                children: [
              Container(
                height: 65.0,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),

                      //color: Color(0xFF9B049B),
                      ),
                child: 
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                      children:[                     
                      Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                  ClipRRect(child: Text('Banking And Food Delivery', style: TextStyle(fontSize: 15.0, fontWeight:FontWeight.bold),)),
                                  ClipRRect(child: Text('Spicing catering ltd')),
                                  Row(children: [
                                    Icon(Icons.remove, color: Colors.red, size: 14.0,),
                                    Text('N 12,000'),
                                    Icon(Icons.arrow_downward, color: Colors.red, size: 14.0,),
                                  ],),                        
                        ],),
                        ]
                  ),
                ),
                ),
              Expanded(
                child:  Container(
                height: 55.0,
                
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.grey),
                  color: Colors.green,
                   borderRadius: BorderRadius.circular(8),

                      //color: Color(0xFF9B049B),
                      ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    ClipRect(child: Text('EXPENSES',style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white))),
                    
                   
                   ],
                  ),
                ),
                ),
              )
              ],),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width/4.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF9B049B),
                    
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Design', textAlign: TextAlign.center, style: TextStyle(color:Colors.white,),),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 100,                   
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      ClipRRect(child: Text('Banking And Food Delivery', style: TextStyle(fontSize: 15.0, fontWeight:FontWeight.bold),)),
                      ClipRRect(child: Text('Spicing catering ltd')),                      
                    ],),
                  ),
                  SizedBox(width: 2),

                  Expanded(
                      child: Row(children: [
                      Icon(Icons.remove, color: Colors.red, size: 14.0,),
                      Text('N 12,000'),
                      Icon(Icons.arrow_downward, color: Colors.red, size: 14.0,),
                    ],),
                  )
                ]
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}
