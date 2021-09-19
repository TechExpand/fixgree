


import 'package:flutter/material.dart';
bool _isDialogShowing = false;

 generalGuild({context,
   showdot,
   message,
   Alignment alignment,
   opacity,
   height, 
   Function whenComplete}){
  height= height==null?0.0:height;
  showGeneralDialog(
      barrierColor: Colors.transparent,
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
          child: Opacity(
              opacity: a1.value,
              child: AnimatedContainer(
                    height: 300,
                    duration: Duration(seconds: 1),
                    margin: const EdgeInsets.all(3.0),
                    child: Align(
                      alignment: alignment,
                      child: Material(
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: Material(
                                elevation: 4,
                                color:  Color(0xFF9B049B).withOpacity(opacity),
                                shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(200),
                                  side:BorderSide(color:Colors.white,
                                      width: 4,
                                      style: BorderStyle.solid) ,
                                ),
                                child: AnimatedContainer(
                                  height: 250,
                                  duration: Duration(seconds: 1),
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 200,
                                          height: 250,
                                          child: StatefulBuilder(builder: (context, setState) {
                                            return Container(
                                              height: 250.0,
                                              color: Colors.transparent,
                                              //could change this to Color(0xFF737373),
                                              //so you don't have to change MaterialApp canvasColor
                                              child: SingleChildScrollView(
                                                physics: BouncingScrollPhysics(),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(height: height,),
                                                    Align(
                                                      alignment: Alignment.center,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [

                                                            Expanded(
                                                              child: Text(message,
                                                                textAlign: TextAlign.center, style:
                                                              TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors.white,
                                                                ),
                                                              // maxLines: 7,
                                                              //   overflow: TextOverflow.ellipsis,
                                                              //   softWrap: true,
                                                              ),
                                                            ),
                                                            showdot==null||showdot==false?Container():InkWell(
                                                              onTap: (){
                                                                Navigator.pop(context);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top:4.0),
                                                                child: Icon(Icons.more_vert, color: Colors.white,),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )

                                                  ],
                                                ),
                                              ),
                                            );

                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  )
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {}).whenComplete(() {
    whenComplete();
  });
}





