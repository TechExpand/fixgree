import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(child: Text('')),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder:(context, index){
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 10),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          'Product 1',
                          style: TextStyle(color: Colors.orange, fontSize: 19),
                        ),
                        Spacer(),
                        Container(
                          width: 66,
                          height: 40,
                          child: Center(
                              child: Text('Remove',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))),
                          color: Colors.orange,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0, right: 16, top: 16),
                child: Row(
                  children: [
                    Text('Price',  style: TextStyle(
                      color: Colors.purple,
                    )),
                    Spacer(),
                    Text('\$200',  style: TextStyle(
                      color: Colors.purple,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0, right: 16, top: 16),
                child: Row(
                  children: [
                    Text('Quantity',  style: TextStyle(
                      color: Colors.purple,
                    )),
                    Spacer(),
                    Text('2',  style: TextStyle(
                      color: Colors.purple,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0, right: 16, top: 16),
                child: Row(
                  children: [
                    Text('Discount',  style: TextStyle(
                      color: Colors.purple,
                    )),
                    Spacer(),
                    Text('10%',  style: TextStyle(
                      color: Colors.purple,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0, right: 16, ),
                child: Divider(thickness: 2,),
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0, right: 16, top: 16),
                child: Row(
                  children: [
                    Text('Subtotal',  style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20
                    )),
                    Spacer(),
                    Text('\$360',  style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20
                    )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
