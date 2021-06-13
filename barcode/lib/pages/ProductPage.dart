

import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Product Name', style: TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(
        child: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top:8.0, bottom: 8),
              width: MediaQuery.of(context).size.width,
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 9,
                itemBuilder:(context, index){
                  return   Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Container(
                      child: Center(child: Text('Image ${index}')),
                      height: 120,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.purple),
                      ),
                    ),
                  );
                }

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0, left: 5),
                    child: Text('Description', style: TextStyle(color: Colors.purple, fontSize: 17),),
                  ),
                ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text('This is the description of all the products about this product'),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(top:10.0, left: 5),
                  child: Text('Price', style: TextStyle(color: Colors.purple, fontSize: 17),),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text('\$1000'),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(top:10.0, left: 5),
                  child: Text('Discount', style: TextStyle(color: Colors.purple, fontSize: 17),),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text('20%'),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(top:10.0, left: 5),
                  child: Text('Amount Payable', style: TextStyle(color: Colors.purple, fontSize: 17),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text('0.20*\$100', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(color: Colors.orange,),
          ),
      Padding(
        padding: const EdgeInsets.only(bottom: 30.0, left: 25, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 170,
              padding: EdgeInsets.only(
                top: 24,
                bottom: 50,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(18)),
              child: FlatButton(
                onPressed: () {},
                color: Colors.orange,
                disabledColor: Colors.orange[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18)),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 45.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Add to Cart",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 170,
              padding: EdgeInsets.only(
                top: 24,
                bottom: 50,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(18)),
              child: FlatButton(
                onPressed: () {

                },
                color: Colors.purple[100],
                disabledColor: Colors.orange[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18)),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 45.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),



      ) ],
        ),
      ),
    );
  }
}
