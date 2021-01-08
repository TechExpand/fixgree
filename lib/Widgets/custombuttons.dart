
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void ConverterButtonTapCallback({String buttonText});

class CustomButton extends StatelessWidget {
  CustomButton(
      {this.text, this.onTap, this.isEqual: false, this.isClear: false});

  final String text;
  final ConverterButtonTapCallback onTap;
  final bool isEqual;
  final bool isClear;

  @override
  Widget build(BuildContext context) {
    if (isClear)
      return Container(
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () => onTap(buttonText: 'C'),
          child: Icon(
            Icons.backspace,
            color: Color(0xFFAEAEAE),
            size: 22,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          splashColor: Colors.blueGrey[100],
        ),
      );
    else if (!isEqual)
      return Container(
        child: FloatingActionButton(
          heroTag: null,
          focusColor: Colors.blueGrey[100],
          onPressed: () => onTap(buttonText: text),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Firesans',
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9B049B),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          splashColor: Colors.blueGrey[100],
        ),
      );
    else
      return Container(
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () => onTap(buttonText: '='),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 24,
          ),
          elevation: 0,
          backgroundColor: Color(0xFF9B049B),
          splashColor: Colors.blueGrey[100],
        ),
      );
  }
}
